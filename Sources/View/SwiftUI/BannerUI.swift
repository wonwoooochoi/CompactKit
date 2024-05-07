//
//  BannerUI.swift
//  
//
//  Created by Wonwoo Choi on 5/7/24.
//

import SwiftUI
import GoogleMobileAds
import FirebaseCrashlytics
import UIKitExtension

public struct BannerUI: View {
    public let adUnitID: String
    
    public var body: some View {
        HStack(spacing: 0) {
            AdMobBannerUI(adUnitID: adUnitID)
                .padding(.horizontal, (UIApplication.shared.screenSize.width - GADAdSizeBanner.size.width) / 2)
        }
        .frame(height: 50)
    }
}

fileprivate struct AdMobBannerUI: UIViewControllerRepresentable {
    let adUnitID: String
    private let bannerView = GAMBannerView(adSize: GADAdSizeBanner)
    private let bannerViewDelegate = AdMobBannerViewDelegate()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = UIViewController()
        bannerViewController.view.addSubview(bannerView)
        bannerViewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
        
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerView.delegate = bannerViewDelegate
        
        return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        bannerView.load(GADRequest())
    }
}

// MARK: - GADBannerViewDelegate (AdMob)

fileprivate class AdMobBannerViewDelegate: NSObject, GADBannerViewDelegate {
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        Crashlytics.crashlytics().record(error: error)
        bannerView.load(GAMRequest())
    }
}
