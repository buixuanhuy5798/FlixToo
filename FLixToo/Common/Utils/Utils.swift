//
//  Utils.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    class func keyWindow() -> UIWindow? {
        return UIApplication.shared.windows.first
    }
}

class Utils {
    class func isNotchDevice() -> Bool {
        let safeAreaInsetsBottom = UIApplication.keyWindow()?.safeAreaInsets.bottom ?? 0.0
        return safeAreaInsetsBottom > 0.0
    }
    
    class func swapRootViewController(_ newRootViewController: UIViewController, completion: (() -> Void)? = nil) {
        guard let window = UIApplication.keyWindow() else {
            return
        }
        window.rootViewController = newRootViewController
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil) { _ in
            completion?()
        }
    }
    
    class func getUrlImage(path: String) -> URL? {
        let fullURLString = AppConstant.imageUrl + path
        return URL(string: fullURLString)
    }
    
    class func calculateTime(_ timeValue: Int) -> String {
        let timeMeasure = Measurement(value: Double(timeValue), unit: UnitDuration.minutes)
        let hours = timeMeasure.converted(to: .hours)
        if hours.value > 1 {
            let minutes = Int(timeMeasure.value.truncatingRemainder(dividingBy: 60))
            let hourValue = Int(hours.value)
            return "\(hourValue)h \(minutes)min"
        }
        return String(format: "%.d %@", timeMeasure.value, "min")
    }
    
    class func convertDateFormatString(dateString: String, inputFormat: String, outputFormat: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        guard let date = inputFormatter.date(from: dateString) else {
            return ""
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        let formattedDateString = outputFormatter.string(from: date)
        return formattedDateString
    }
}
