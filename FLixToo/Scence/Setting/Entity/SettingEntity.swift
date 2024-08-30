//  
//  SettingEntity.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

enum SettingOption {
    case contactUs
    case privacyPolicy
    case shareApp
    case rateApp
    case appIcon
    case appName
    case appVersion
    
    func getTitle() -> String {
        switch self {
        case .contactUs:
            return "Contact us"
        case .privacyPolicy:
            return "Privacy Policy"
        case .shareApp:
            return "Share App"
        case .rateApp:
            return "Rate App"
        case .appIcon:
            return "App icons"
        case .appName:
            return "App name"
        case .appVersion:
            return "Version"
        }
    }
    
    func getIcon() -> UIImage? {
        switch self {
        case .contactUs:
            return UIImage(named: "setting_contact_us")
        case .privacyPolicy:
            return UIImage(named: "setting_privacy_policy")
        case .shareApp:
            return UIImage(named: "setting_share_app")
        case .rateApp:
            return UIImage(named: "setting_rate_app")
        case .appIcon:
            return UIImage(named: "setting_app_icons")
        default:
            return nil
        }
    }
}
