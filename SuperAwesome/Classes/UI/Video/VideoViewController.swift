//
//  VideoViewController.swift
//  SuperAwesome
//
//  Created by Gabriel Coman on 17/12/2018.
//

import UIKit

@objc(SAVideoViewController) class VideoViewController: UIViewController, Injectable {

    private lazy var controller: AdControllerType = dependencies.resolve()
    private lazy var orientationProvider: OrientationProviderType = dependencies.resolve()
    private lazy var stringProvider: StringProviderType = dependencies.resolve()
    private var videoPlayer: AwesomeVideoPlayer!
    private var chrome: AdSocialVideoPlayerControlsView!
    private var logger: LoggerType = dependencies.resolve(param: VideoViewController.self)
    private let config: AdConfig
    private let control: VideoPlayerControls = VideoPlayerController()
    private let videoEvents: VideoEvents
    private var completed: Bool = false
    private var closeDialog: UIAlertController?
    private let accessibilityPrefix = "SuperAwesome.Video."

    init(adResponse: AdResponse, callback: AdEventCallback?, config: AdConfig) {
        self.config = config
        videoEvents = VideoEvents(adResponse)
        super.init(nibName: nil, bundle: nil)
        controller.adResponse = adResponse
        controller.callback = callback
        controller.parentalGateEnabled = config.isParentalGateEnabled
        controller.bumperPageEnabled = config.isBumperPageEnabled
        controller.videoDelegate = self
        videoEvents.delegate = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override var prefersStatusBarHidden: Bool { true }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { .fade }

    @available(iOS 11.0, *)
    override var prefersHomeIndicatorAutoHidden: Bool { true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        orientationProvider.findSupportedOrientations(config.orientation, super.supportedInterfaceOrientations)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use this externally!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // initial view setup
        view.accessibilityIdentifier = "\(accessibilityPrefix)Screen"
        view.backgroundColor = .black
        view.layoutMargins = .zero

        // swiftlint:disable discarded_notification_center_observer
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                               object: nil,
                                               queue: .main) { [weak self] notification in
            self?.willEnterForeground(notification)
        }

        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                               object: nil,
                                               queue: .main) { [weak self] _ in
            self?.didEnterBackground()
        }
        // swiftlint:enable discarded_notification_center_observer

        // setup video player
        videoPlayer = AwesomeVideoPlayer()
        videoPlayer.accessibilityIdentifier = "\(accessibilityPrefix)Player"
        videoPlayer.setControls(controller: control)
        videoPlayer.layoutMargins = .zero
        videoPlayer.setDelegate(delegate: self)
        view.addSubview(videoPlayer)
        videoPlayer.bind(
            toTheEdgesOf: view,
            insets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        )

        // setup chrome
        chrome = AdSocialVideoPlayerControlsView(smallClick: config.showSmallClick,
                                                 showSafeAdLogo: config.showSafeAdLogo)
        chrome.layoutMargins = .zero
        chrome.setCloseAction { [weak self] in
            self?.closeAction()
        }
        chrome.setClickAction { [weak self] in
            self?.clickAction()
        }
        chrome.setPadlockAction { [weak self] in
            self?.controller.handleSafeAdTap()
        }
        chrome.setVolumeAction { [weak self] in
            self?.volumeAction()
        }
        videoPlayer.setControlsView(
            controllerView: chrome,
            insets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        )

        if let avPlayer = videoPlayer.getAVPlayer() {
            let muted = config.shouldMuteOnStart
            avPlayer.isMuted = muted
            chrome.setMuted(muted)

            if muted {
                chrome.makeVolumeButtonVisible()
            }
        }

        if config.closeButtonState == .visibleImmediately {
            chrome.makeCloseButtonVisible()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // play ad
        DispatchQueue.main.async { [weak self] in
            if let url = self?.controller.filePathUrl, self?.control.getDuration() == 0 {
                self?.control.play(url: url)
            } else {
                self?.control.start()
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        control.pause()
        super.viewWillDisappear(animated)
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
    }

    private func didEnterBackground() {
        closeDialog?.dismiss(animated: true)
        closeDialog = nil
    }

    @objc
    func willEnterForeground(_ notification: Notification) {
        control.start()
    }

    private func clickAction() {
        controller.handleAdTapForVast()
    }

    private func closeAction() {
        if config.shouldShowCloseWarning && !completed {
            control.pause()
            closeDialog = showQuestionDialog(title: stringProvider.closeDialogTitle,
                                             message: stringProvider.closeDialogMessage,
                                             yesTitle: stringProvider.closeDialogCloseAction,
                                             noTitle: stringProvider.closeDialogResumeAction) { [weak self] in
                self?.close()
            } noAction: { [weak self] in
                self?.control.start()
            }
        } else {
            close()
        }
    }

    private func volumeAction() {
        if let avPlayer = videoPlayer.getAVPlayer() {
            let toggle = !avPlayer.isMuted
            avPlayer.isMuted = toggle
            chrome.setMuted(toggle)
        }
    }

    private func close() {
        dismiss(animated: true) { [weak self] in
            self?.controller.close()
        }
        videoPlayer.destroy()
    }
}

extension VideoViewController: VideoEventsDelegate {
    func hasBeenVisible() {
        controller.triggerViewableImpression()
        controller.triggerDwellTime()

        if config.closeButtonState == .visibleWithDelay {
            chrome.makeCloseButtonVisible()
        }
    }
}

extension VideoViewController: AdControllerVideoDelegate {
    func controllerDidRequestPlayVideo() {
        control.start()
    }

    func controllerDidRequestPauseVideo() {
        control.pause()
    }
}

extension VideoViewController: VideoPlayerDelegate {
    func didPrepare(videoPlayer: VideoPlayer, time: Int, duration: Int) {
        controller.adShown()
    }

    func didUpdateTime(videoPlayer: VideoPlayer, time: Int, duration: Int) {
        videoEvents.time(player: videoPlayer, time: time, duration: duration)
    }

    func didComplete(videoPlayer: VideoPlayer, time: Int, duration: Int) {
        completed = true
        videoEvents.complete(player: videoPlayer, time: time, duration: duration)
        chrome.makeCloseButtonVisible()
        controller.adEnded()

        if config.shouldCloseAtEnd {
            closeAction()
        }
    }

    func didError(videoPlayer: VideoPlayer, error: Error, time: Int, duration: Int) {
        videoEvents.error(player: videoPlayer, time: time, duration: duration)
        controller.adFailedToShow()
        closeAction()
    }
}
