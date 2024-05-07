//
//  BannerView.swift
//  
//
//  Created by Wonwoo Choi on 5/7/24.
//

import UIKit
import GoogleMobileAds
import FirebaseCrashlytics

public final class BannerView: UIView {
    private var adMob: GAMBannerView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
}

// MARK: - Set Up

private extension BannerView {
    func setUp() {
        backgroundColor = .clear
        setUpAdMob()
    }
    
    func setUpAdMob() {
        adMob = GAMBannerView(adSize: GADAdSizeBanner)
        adMob.translatesAutoresizingMaskIntoConstraints = false
        adMob.delegate = self
        
        addSubview(adMob)
        
        NSLayoutConstraint.activate([
            adMob.centerXAnchor.constraint(equalTo: centerXAnchor),
            adMob.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - Public

public extension BannerView {
    func configureAdMob(unitID: String, rootViewController: UIViewController) {
        adMob.adUnitID = unitID
        adMob.rootViewController = rootViewController
        adMob.load(GAMRequest())
    }
}

// MARK: - GADBannerViewDelegate (AdMob)

extension BannerView: GADBannerViewDelegate {
    public func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        Crashlytics.crashlytics().record(error: error)
        adMob.load(GAMRequest())
    }
}
