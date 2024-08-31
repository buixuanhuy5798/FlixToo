//
//  AppIconCell.swift
//  FLixToo
//
//  Created by buixuanhuy on 31/08/2024.
//

import UIKit
import Reusable

enum AppIconType {
    case original
    case orange
    case blackShade
    case whitebeans
    case purpleTheme
    case yellowish
    
    func getName() -> String {
        switch self {
        case .original:
            return "app_icon_original"
        case .orange:
            return "app_icon_orange"
        case .blackShade:
            return "app_icon_black_shade"
        case .whitebeans:
            return "app_icon_white_beans"
        case .purpleTheme:
            return "app_icon_purple_theme"
        case .yellowish:
            return "app_icon_yellowish"
        }
    }
    func getIcon() -> UIImage? {
        switch self {
        case .original:
            return UIImage(named: "app_icon_original")
        case .orange:
            return UIImage(named: "app_icon_orange")
        case .blackShade:
            return UIImage(named: "app_icon_black_shade")
        case .whitebeans:
            return UIImage(named: "app_icon_white_beans")
        case .purpleTheme:
            return UIImage(named: "app_icon_purple_theme")
        case .yellowish:
            return UIImage(named: "app_icon_yellowish")
        }
    }
    
    func getTitle() -> String {
        switch self {
        case .original:
            return "Original"
        case .orange:
            return "Orange"
        case .blackShade:
            return "Black Shade"
        case .whitebeans:
            return "White beans"
        case .purpleTheme:
            return "Purple Theme"
        case .yellowish:
            return "Yellowish"
        }
    }
}

class AppIconCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var selectIconView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: VerticalAlignedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.contentMode = .top
        titleLabel.textColor = .white
        titleLabel.font = Typography.fontRegular14
    }
    
    func setContentForCell(data: AppIconType, showIconSelect: Bool) {
        imageView.image = data.getIcon()
        titleLabel.text = data.getTitle()
        selectIconView.isHidden = !showIconSelect
    }
}
