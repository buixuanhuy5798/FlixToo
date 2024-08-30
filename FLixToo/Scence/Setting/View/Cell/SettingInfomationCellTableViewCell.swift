//
//  SettingInfomationCellTableViewCell.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 30/8/24.
//

import UIKit
import Reusable

class SettingInfomationCellTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentLabel.textColor = UIColor(hex: "C6C6C6")
        contentLabel.font = Typography.fontMedium14
        titleLabel.textColor = .white
        titleLabel.font = Typography.fontMedium14
    }

    func setContentForCell(title: String, content: String) {
        contentLabel.text = content
        titleLabel.text = title
    }
}
