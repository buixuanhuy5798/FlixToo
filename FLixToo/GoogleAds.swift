//
//  ViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 22/8/24.
//

import UIKit
import GoogleMobileAds

class AppOpenAdManager: NSObject, GADFullScreenContentDelegate {
  var appOpenAd: GADAppOpenAd?
  var isLoadingAd = false
  var isShowingAd = false

  static let shared = AppOpenAdManager()

    
    private func loadAd() async {
      // Do not load ad if there is an unused ad or one is already loading.
      if isLoadingAd || isAdAvailable() {
        return
      }
      isLoadingAd = true

      do {
        appOpenAd = try await GADAppOpenAd.load(
            withAdUnitID: AppConstant.gooogleAdOpenApp, request: GADRequest())
      } catch {
        print("App open ad failed to load with error: \(error.localizedDescription)")
      }
      isLoadingAd = false
    }

    func showAdIfAvailable() {
      guard !isShowingAd else { return }
      if !isAdAvailable() {
        Task {
          await loadAd()
        }
        return
      }

      if let ad = appOpenAd {
        isShowingAd = true
        ad.present(fromRootViewController: nil)
      }
    }

  private func isAdAvailable() -> Bool {
    // Check if ad exists and can be shown.
    return appOpenAd != nil
  }
}

class Interstitial: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    static var shared: Interstitial = Interstitial()
    
    /// Default initializer of interstitial class
    override init() {
        super.init()
        loadInterstitial()
    }
    
    /// Request AdMob Interstitial ads
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AppConstant.googleAdsInter, request: request, completionHandler: { [self] ad, error in
            if ad != nil { interstitial = ad }
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    func showInterstitialAds() {
        if self.interstitial != nil {
            guard let root = rootController else { return }
            self.interstitial?.present(fromRootViewController: root)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadInterstitial()
    }
}

var rootController: UIViewController? {
    var root = UIApplication.shared.windows.first?.rootViewController
    if let presenter = root?.presentedViewController { root = presenter }
    return root
}
