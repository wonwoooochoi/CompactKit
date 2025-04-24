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
    private let adUnitID: String
    private let delay: Int
    private let retry: Int
    
    public init(adUnitID: String, delay: Int = 5, retry: Int = 5) {
        self.adUnitID = adUnitID
        self.delay = delay
        self.retry = retry
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            AdMobBannerUI(adUnitID: adUnitID, delay: delay, retry: retry)
                .padding(.horizontal, (UIApplication.shared.screenSize.width - GADAdSizeBanner.size.width) / 2)
        }
        .frame(height: 50)
    }
}

fileprivate struct AdMobBannerUI: UIViewControllerRepresentable {
    private let adUnitID: String
    private let bannerView: GAMBannerView
    private let bannerViewDelegate: AdMobBannerViewDelegate
    
    init(adUnitID: String, delay: Int, retry: Int) {
        self.adUnitID = adUnitID
        self.bannerView = GAMBannerView(adSize: GADAdSizeBanner)
        self.bannerViewDelegate = AdMobBannerViewDelegate(delay: delay, retry: retry)
    }
    
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
    private let delay: Int
    private let retry: Int
    private var retried = 0
    
    init(delay: Int, retry: Int) {
        self.delay = delay
        self.retry = retry
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        Crashlytics.crashlytics().record(error: error)
        
        guard retried < retry else { return }
        retried += 1
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(delay)) {
            bannerView.load(GAMRequest())
        }
    }
}
