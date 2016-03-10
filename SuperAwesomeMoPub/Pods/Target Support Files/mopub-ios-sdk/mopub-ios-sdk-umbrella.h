#import <UIKit/UIKit.h>

#import "MPBannerAdManager.h"
#import "MPBannerAdManagerDelegate.h"
#import "MPBannerCustomEventAdapter.h"
#import "MPBaseBannerAdapter.h"
#import "MPPrivateBannerCustomEventDelegate.h"
#import "MPAdAlertGestureRecognizer.h"
#import "MPAdAlertManager.h"
#import "MPActivityViewControllerHelper+TweetShare.h"
#import "MPActivityViewControllerHelper.h"
#import "MPAdBrowserController.h"
#import "MPAdConfiguration.h"
#import "MPAdDestinationDisplayAgent.h"
#import "MPAdServerCommunicator.h"
#import "MPAdServerURLBuilder.h"
#import "MPAPIEndpoints.h"
#import "MPClosableView.h"
#import "MPEnhancedDeeplinkRequest.h"
#import "MPFacebookKeywordProvider.h"
#import "MPKeywordProvider.h"
#import "MPLastResortDelegate+EventKit.h"
#import "MPLastResortDelegate.h"
#import "MPProgressOverlayView.h"
#import "MPURLActionInfo.h"
#import "MPURLResolver.h"
#import "MPVideoConfig.h"
#import "MPXMLParser.h"
#import "MPLogEvent+NativeVideo.h"
#import "MPLogEvent.h"
#import "MPLogEventCommunicator.h"
#import "MPLogEventRecorder.h"
#import "MPNetworkManager.h"
#import "MPQRunLoopOperation.h"
#import "MPRetryingHTTPOperation.h"
#import "FABAttributes.h"
#import "FABKitProtocol.h"
#import "Fabric+FABKits.h"
#import "Fabric.h"
#import "MPAdWebView.h"
#import "MPAdWebViewAgent.h"
#import "MPHTMLBannerCustomEvent.h"
#import "MPHTMLInterstitialCustomEvent.h"
#import "MPHTMLInterstitialViewController.h"
#import "MPBaseInterstitialAdapter.h"
#import "MPInterstitialAdManager.h"
#import "MPInterstitialAdManagerDelegate.h"
#import "MPInterstitialCustomEventAdapter.h"
#import "MPInterstitialViewController.h"
#import "MPPrivateInterstitialCustomEventDelegate.h"
#import "MPCoreInstanceProvider.h"
#import "MPInstanceProvider.h"
#import "MPVASTTracking.h"
#import "MPForceableOrientationProtocol.h"
#import "MPMRAIDBannerCustomEvent.h"
#import "MPMRAIDInterstitialCustomEvent.h"
#import "MPMRAIDInterstitialViewController.h"
#import "MRBridge.h"
#import "MRBundleManager.h"
#import "MRCalendarManager.h"
#import "MRCommand.h"
#import "MRConstants.h"
#import "MRController.h"
#import "MRError.h"
#import "MRExpandModalViewController.h"
#import "MRImageDownloader.h"
#import "MRNativeCommandHandler.h"
#import "MRPictureManager.h"
#import "MRProperty.h"
#import "MRVideoPlayerManager.h"
#import "NSHTTPURLResponse+MPAdditions.h"
#import "NSJSONSerialization+MPAdditions.h"
#import "NSURL+MPAdditions.h"
#import "UIButton+MPAdditions.h"
#import "UIColor+MPAdditions.h"
#import "UIView+MPAdditions.h"
#import "UIWebView+MPAdditions.h"
#import "MPAnalyticsTracker.h"
#import "MPError.h"
#import "MPGeolocationProvider.h"
#import "MPGlobal.h"
#import "MPIdentityProvider.h"
#import "MPInternalUtils.h"
#import "MPLogging.h"
#import "MPLogProvider.h"
#import "MPReachability.h"
#import "MPSessionTracker.h"
#import "MPStoreKitProvider.h"
#import "MPTimer.h"
#import "MPUserInteractionGestureRecognizer.h"
#import "MPVASTAd.h"
#import "MPVASTCompanionAd.h"
#import "MPVASTCreative.h"
#import "MPVASTDurationOffset.h"
#import "MPVASTIndustryIcon.h"
#import "MPVASTInline.h"
#import "MPVASTLinearAd.h"
#import "MPVASTMacroProcessor.h"
#import "MPVASTManager.h"
#import "MPVASTMediaFile.h"
#import "MPVASTModel.h"
#import "MPVASTResource.h"
#import "MPVASTResponse.h"
#import "MPVASTStringUtilities.h"
#import "MPVASTTrackingEvent.h"
#import "MPVASTWrapper.h"
#import "MoPub-Bridging-Header.h"
#import "MoPub.h"
#import "MPAdConversionTracker.h"
#import "MPAdView.h"
#import "MPBannerCustomEvent.h"
#import "MPBannerCustomEventDelegate.h"
#import "MPConstants.h"
#import "MPInterstitialAdController.h"
#import "MPInterstitialCustomEvent.h"
#import "MPInterstitialCustomEventDelegate.h"
#import "MPNativeAdRequest+MPNativeAdSource.h"
#import "MPAdPlacerInvocation.h"
#import "MPCollectionViewAdPlacerCell.h"
#import "MPDiskLRUCache.h"
#import "MPImageDownloadQueue.h"
#import "MPMoPubNativeAdAdapter.h"
#import "MPMoPubNativeCustomEvent.h"
#import "MPNativeAd+Internal.h"
#import "MPNativeAdRendererImageHandler.h"
#import "MPNativeAdSourceQueue.h"
#import "MPNativeAdUtils.h"
#import "MPNativeCache.h"
#import "MPNativePositionResponseDeserializer.h"
#import "MPNativePositionSource.h"
#import "MPNativeView.h"
#import "MPStaticNativeAdImpressionTimer.h"
#import "MPTableViewAdPlacerCell.h"
#import "MPTableViewCellImpressionTracker.h"
#import "MPAdPositioning.h"
#import "MPClientAdPositioning.h"
#import "MPCollectionViewAdPlacer.h"
#import "MPNativeAd.h"
#import "MPNativeAdAdapter.h"
#import "MPNativeAdConstants.h"
#import "MPNativeAdData.h"
#import "MPNativeAdDelegate.h"
#import "MPNativeAdError.h"
#import "MPNativeAdRenderer.h"
#import "MPNativeAdRendererConfiguration.h"
#import "MPNativeAdRendererSettings.h"
#import "MPNativeAdRendering.h"
#import "MPNativeAdRenderingImageLoader.h"
#import "MPNativeAdRequest.h"
#import "MPNativeAdRequestTargeting.h"
#import "MPNativeAdSource.h"
#import "MPNativeAdSourceDelegate.h"
#import "MPNativeCustomEvent.h"
#import "MPNativeCustomEventDelegate.h"
#import "MPServerAdPositioning.h"
#import "MPStaticNativeAdRenderer.h"
#import "MPStaticNativeAdRendererSettings.h"
#import "MPStreamAdPlacementData.h"
#import "MPStreamAdPlacer.h"
#import "MPTableViewAdPlacer.h"
#import "MOPUBActivityIndicatorView.h"
#import "MOPUBAVPlayer.h"
#import "MOPUBAVPlayerView.h"
#import "MOPUBFullscreenPlayerViewController.h"
#import "MOPUBNativeVideoAdAdapter.h"
#import "MOPUBNativeVideoAdConfigValues.h"
#import "MOPUBNativeVideoCustomEvent.h"
#import "MOPUBNativeVideoImpressionAgent.h"
#import "MOPUBPlayerManager.h"
#import "MOPUBPlayerView.h"
#import "MOPUBPlayerViewController.h"
#import "MOPUBReplayView.h"
#import "MOPUBNativeVideoAdRenderer.h"
#import "MOPUBNativeVideoAdRendererSettings.h"
#import "MPRewardedVideoAdapter.h"
#import "MPRewardedVideoAdManager.h"
#import "MPMediationSettingsProtocol.h"
#import "MPRewardedVideo.h"
#import "MPRewardedVideoCustomEvent.h"
#import "MPRewardedVideoError.h"
#import "MPRewardedVideoReward.h"

FOUNDATION_EXPORT double mopub_ios_sdkVersionNumber;
FOUNDATION_EXPORT const unsigned char mopub_ios_sdkVersionString[];
