//
//  SearchNameTableViewCell.swift
//  FLixToo
//
//  Created by NamTrinh on 27/08/2024.
//

import UIKit
import Reusable

final class SearchNameTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(title: String) {
        nameLabel.text = title
    }
}
