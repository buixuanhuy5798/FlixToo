//
//  CategoryCell.swift
//  FLixToo
//
//  Created by buixuanhuy on 24/08/2024.
//

import UIKit
import Reusable

class CategoryCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = Typography.fontSemibold16
        titleLabel.textColor = .white
    }
    
    func setContentForCell(data: HomeCategoryOption) {
        titleLabel.text = data.getTitle()
        imageView.image = data.getImage()
    }
}
