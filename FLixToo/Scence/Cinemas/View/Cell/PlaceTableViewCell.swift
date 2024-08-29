//
//  PlaceTableViewCell.swift
//  FLixToo
//
//  Created by NamTrinh on 27/08/2024.
//

import UIKit
import Reusable

final class PlaceTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configCell(title: String) {
        self.titleLabel.text = title
    }
}
