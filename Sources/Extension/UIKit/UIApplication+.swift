//
//  UIApplication+.swift
//
//
//  Created by Wonwoo Choi on 4/7/24.
//

import UIKit

public extension UIApplication {
    var connectedWindowScenes: [UIWindowScene] {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
    }
    
    var window: UIWindow? {
        connectedWindowScenes.first?.windows
            .first { $0.isKeyWindow }
    }
    
    var screenSize: CGSize {
        connectedWindowScenes.first?.screen.bounds.size ?? .zero
    }
    
    var topMostViewController: UIViewController? {
        window?.rootViewController?.topMostViewController
    }
}
