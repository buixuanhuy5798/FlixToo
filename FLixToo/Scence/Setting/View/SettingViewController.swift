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
    var settingData: [[SettingOption]] = [[.contactUs, .privacyPolicy, .shareApp, .rateApp], [.appIcon]]
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
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingOptionCell.self)
        cell.setContentForCell(data: settingData[indexPath.section][indexPath.row])
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
