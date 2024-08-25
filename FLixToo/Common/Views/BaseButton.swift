//
//  BaseButton.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

class BaseOutlineButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
    }
}

class BaseFillButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let subLayer = CAGradientLayer()
        subLayer.frame = self.bounds
        subLayer.colors = [UIColor(hex: "5666F8").cgColor, UIColor(hex: "1A8BFB").cgColor]
        subLayer.startPoint = CGPoint(x: 0, y: 0.5)
        subLayer.endPoint = CGPoint(x: 1, y: 0.5)
        subLayer.cornerRadius = 18
        layer.insertSublayer(subLayer, at: 0)
        return subLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .selected)
        setTitleColor(.white, for: .disabled)
        setTitleColor(.white, for: .focused)
        tintColor = .clear
        titleLabel?.font = Typography.fontSemibold14
    }
}
