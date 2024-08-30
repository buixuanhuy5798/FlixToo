//
//  MovieTrailerCell.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 30/8/24.
//

import UIKit
import Reusable
import Kingfisher

class MovieTrailerCell: UITableViewCell, NibReusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = Typography.fontSemibold16
        titleLabel.textColor = .white
        selectionStyle = .none
    }
    
    func setContentForCell(data: MovieVideo) {
        titleLabel.text = data.name
        let trailerPath = "https://img.youtube.com/vi/\(data.key ?? "")/0.jpg"
        thumbnailImageView.kf.setImage(
            with: URL(string: trailerPath),
                options: [
                    .loadDiskFileSynchronously,
                    .cacheOriginalImage,
                    .transition(.fade(0.1)),
                ])
    }
    
}
