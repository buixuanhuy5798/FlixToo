//
//  CenimaTableViewCell.swift
//  FLixToo
//
//  Created by NamTrinh on 27/08/2024.
//

import UIKit
import Reusable

final class CenimaTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configCell(title: String, address: String, indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            iconImageView.image = UIImage(named: "ic_cinema2")
        } else if indexPath.row % 3 == 0 {
            iconImageView.image = UIImage(named: "ic_cinema3")
        } else {
            iconImageView.image = UIImage(named: "ic_cinema1")
        }
        titleLabel.text = title
        addressLabel.text = address
    }
}
