//
//  MovieCreditCollectionViewCell.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 29/8/24.
//

import UIKit
import Reusable

class MovieCreditCollectionViewCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var titleLabel: VerticalAlignedLabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.contentMode = .top
        nameLabel.font = Typography.fontSemibold14
        nameLabel.textColor = .white
        titleLabel.font = Typography.fontRegular12
        titleLabel.textColor = .white
    }
    
    func setContentForCell(crew: Cast) {
        nameLabel.text = crew.name
        titleLabel.text = crew.knownForDepartment?.rawValue
    }
}
