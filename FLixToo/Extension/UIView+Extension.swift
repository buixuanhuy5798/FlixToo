//
//  UIView+Extension.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat, width: CGFloat = UIScreen.main.bounds.size.width) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: self.frame.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        layer.masksToBounds = true
    }
}
