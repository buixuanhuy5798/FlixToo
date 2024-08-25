//
//  AppDelegate.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 22/8/24.
//

import UIKit
import Reusable

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        navigateScreen()
        KeychainStorage.shared.apiKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZDQxZWYzMmE0MGQxNWJlMTAyYzYyMzcyMGNjMjg4NiIsIm5iZiI6MTcyNDU2NjQxMy4wMjE0NzYsInN1YiI6IjVkYWZhMTI1ZGMxY2I0MDAxNTI3YjE5ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.cbbx3ypZYoqcXi5e9fTyeU9pXVw28TBEDd_G2fCjUgQ"
        return true
    }

    private func navigateScreen() {
        let introduceController = MainTabBarController()
        window?.rootViewController = introduceController
    }
}

