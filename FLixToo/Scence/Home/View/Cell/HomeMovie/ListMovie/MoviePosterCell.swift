//
//  MoviePosterCell.swift
//  FLixToo
//
//  Created by buixuanhuy on 24/08/2024.
//

import UIKit
import Reusable
import Kingfisher

class MoviePosterCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var nameLabel: VerticalAlignedLabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.contentMode = .top
        nameLabel.font = Typography.fontMedium14
        nameLabel.textColor = .white
    }
    
    func setContentForCell(data: MovieCommonInfomation) {
        nameLabel.text = data.originalTitle
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.posterPath),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
    }
    
    func setContentForCell(data: TvShowCommonInfomation) {
        nameLabel.numberOfLines = 2
        nameLabel.text = data.originalName
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.posterPath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
    }
}
