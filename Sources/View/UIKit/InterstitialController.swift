//
//  InterstitialController.swift
//
//
//  Created by Wonwoo Choi on 5/7/24.
//

import Foundation
import GoogleMobileAds
import FirebaseCrashlytics

public final class InterstitialController: NSObject {
    private let adID: String
    private let skipCount: Int
    private var currentSkipCount: Int
    private var adMobinterstitial: GADInterstitialAd?
    private var adMobDissmissed: (() -> Void)?
    
    private override init() {
        self.adID = ""
        self.skipCount = 0
        self.currentSkipCount = 0
        super.init()
        self.loadAdMobInterstitial()
    }
    
    public init(skipCount: Int = 0) {
        self.adID = ""
        self.skipCount = skipCount
        self.currentSkipCount = skipCount
        super.init()
        self.loadAdMobInterstitial()
    }
    
    public init(adID: String, skipCount: Int = 0) {
        self.adID = adID
        self.skipCount = skipCount
        self.currentSkipCount = skipCount
        super.init()
        self.loadAdMobInterstitial()
    }
}

// MARK: - AdMob

public extension InterstitialController {
    private func loadAdMobInterstitial() {
        guard !adID.isEmpty
        else { return }
        
        GADInterstitialAd.load(withAdUnitID: adID, request: GADRequest()) { [weak self] ad, error in
            if let error {
                self?.adMobinterstitial = nil
                self?.adMobinterstitial?.fullScreenContentDelegate = nil
                Crashlytics.crashlytics().record(error: error)
                
                DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                    self?.loadAdMobInterstitial()
                }
            }
            
            if let ad {
                self?.adMobinterstitial = ad
                self?.adMobinterstitial?.fullScreenContentDelegate = self
            }
        }
    }
    
    func present(_ viewController: UIViewController) {
        if currentSkipCount > 0 {
            currentSkipCount -= 1
        }
        else {
            do {
                try adMobinterstitial?.canPresent(fromRootViewController: viewController)
                currentSkipCount = skipCount
                adMobinterstitial?.present(fromRootViewController: viewController)
            }
            catch {
                Crashlytics.crashlytics().record(error: error)
                loadAdMobInterstitial()
            }
        }
    }
}

// MARK: - GADFullScreenContentDelegate (AdMob)

extension InterstitialController: GADFullScreenContentDelegate {
    public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadAdMobInterstitial()
        adMobDissmissed?()
    }
    
    public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Crashlytics.crashlytics().record(error: error)
        loadAdMobInterstitial()
    }
}
