//
//  ActorCommonInfoCell.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit
import Reusable

class ActorCommonInfoCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.font = Typography.fontMedium14
        nameLabel.textColor = .white
    }

    func setContentForCell(actor: ActorCommonInfo) {
        nameLabel.text = actor.name
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: actor.profilePath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
    }
}
