//
//  SettingOptionCell.swift
//  FLixToo
//
//  Created by buixuanhuy on 24/08/2024.
//

import UIKit
import Reusable

class SettingOptionCell: UITableViewCell, NibReusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        titleLabel.font = Typography.fontSemibold14
        titleLabel.textColor = .white
    }
    
    func setContentForCell(data: SettingOption) {
        titleLabel.text = data.getTitle()
        iconImageView.image = data.getIcon()
    }
}
