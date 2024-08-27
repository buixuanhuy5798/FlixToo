//
//  BaseViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

private struct Constant {
    static let topMostConstraintIdentifier = "topMostConstraint"
    static let notchDeviceNavigationBarHeight: CGFloat = 88.0
    static let normalDeviceNavigationBarHeight: CGFloat = 64.0
    static let notchDeviceLargeNavigationBarHeight: CGFloat = 112.0 // Height large navigation bar has notch
    static let normalDeviceLargeNavigationBarHeight: CGFloat = 86.0 // Height large navigation bar normal
}

class BaseViewController: UIViewController {
    var showHeaderView = true {
        didSet {
            headerView.isHidden = !showHeaderView
        }
    }
    
    var showBackButton = true {
        didSet {
            backButton.isHidden = !showBackButton
        }
    }
    
    let headerView: UIView = {
        let header = UIView()
        header.backgroundColor = .clear
        return header
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "common_background_image")
        return imageView
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_back"), for: .normal)
        return button
    }()
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = Typography.fontBold18
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        return titleLabel
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        guard let title = titleLabel.text, !title.isEmpty else {
            titleLabel.text = title
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    fileprivate func setUpView() {
        view.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        setUpHeader()
    }
    
    private func setUpHeader() {
        var navigationBarHeight: CGFloat = 0
        navigationBarHeight = Utils.isNotchDevice() ? Constant.notchDeviceNavigationBarHeight : Constant.normalDeviceNavigationBarHeight
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = UIApplication.keyWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(navigationBarHeight)
        }
        headerView.addSubview(titleLabel)
        headerView.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(6)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing).offset(2)
        }
        view.constraints.filter {
            $0.identifier == Constant.topMostConstraintIdentifier
        }.forEach {
            $0.constant += navigationBarHeight - statusBarHeight
        }
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        
    }
    
    @objc func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print((String(describing: type(of: self)) + " deinit"))
        NotificationCenter.default.removeObserver(self)
    }
}
