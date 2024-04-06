//
//  UIApplication+.swift
//
//
//  Created by Wonwoo Choi on 4/7/24.
//

import UIKit

public extension UIApplication {
    var activeConnectedScenes: [UIWindowScene] {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
    }
    
    var activeWindow: UIWindow? {
        activeConnectedScenes.first?.windows
            .first { $0.isKeyWindow }
    }
    
    var topMostViewController: UIViewController? {
        activeWindow?.rootViewController?.topMostViewController
    }
}
