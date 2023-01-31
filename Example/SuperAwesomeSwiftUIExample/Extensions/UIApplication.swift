//
//  UIApplication.swift
//  AwesomeAdsSDKKitchenSink
//
//  Created by Myles Eynon on 19/01/2023.
//

import UIKit

extension UIApplication {
    var currentKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }

    var rootViewController: UIViewController? {
        currentKeyWindow?.rootViewController
    }
}
