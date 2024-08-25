//
//  MovieProviderCell.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit
import Reusable

class MovieProviderCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func setContentForCell(data: MovieProvider) {
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.logoPath),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
    }
}
