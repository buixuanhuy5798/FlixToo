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

extension UIView {
    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = self.bounds
        
        if let sublayers = self.layer.sublayers {
            for layer in sublayers where layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func applyGradient(colors: [UIColor], cornerRadius: CGFloat, locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
            // Remove existing gradient layer if any
            if let sublayers = self.layer.sublayers {
                for layer in sublayers where layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
            
            // Create and configure the gradient layer
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.locations = locations
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            
            // Add the gradient layer to the view
            self.layer.insertSublayer(gradientLayer, at: 0)
            
            // Apply the corner radius to the view
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    
    func removeGradientLayer() {
        if let sublayers = self.layer.sublayers {
            for layer in sublayers where layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
}
