//  
//  SettingViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable

class SettingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: SettingPresenterProtocol!
    var settingData: [[SettingOption]] = [[.contactUs, .privacyPolicy, .shareApp, .rateApp], [.appIcon], [.appName, .appVersion]]
    var sectionTitle = ["General", "About App", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        title = "Setting"
        showBackButton = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: SettingOptionCell.self)
        tableView.register(cellType: SettingInfomationCellTableViewCell.self)
    }
    
    func requestAppStoreReview() {
//        let hasRequestedReviewKey = "hasRequestedReview"
//
//        let hasRequestedReview = UserDefaults.standard.bool(forKey: hasRequestedReviewKey)
//
//        if !hasRequestedReview {
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                SKStoreReviewController.requestReview(in: windowScene)
//                UserDefaults.standard.set(true, forKey: hasRequestedReviewKey)
//            }
//        }
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingInfomationCellTableViewCell.self)
            if indexPath.row == 0 {
                cell.setContentForCell(title: "App name", content: "FlixToo")
            } else {
                cell.setContentForCell(title: "Version", content: UIApplication.appVersion ?? "")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingOptionCell.self)
            cell.setContentForCell(data: settingData[indexPath.section][indexPath.row])
            return cell
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 {
            return nil
        }
        let header = UIView()
        header.backgroundColor = .clear
        let titleLabel = UILabel()
        header.addSubview(titleLabel)
        titleLabel.textColor = UIColor(hex: "AAAAAA")
        titleLabel.font = Typography.fontSemibold14
        titleLabel.text = sectionTitle[section]
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.center.equalToSuperview()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension SettingViewController:SettingViewProtocol {
}

extension SettingViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.setting
}
