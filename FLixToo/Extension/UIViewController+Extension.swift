//
//  UIViewController+Extension.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 28/8/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showCommonError(message: String) {
        // create the alert
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
