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

    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var nameLabel: VerticalAlignedLabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var onTapDelete: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.contentMode = .top
        nameLabel.font = Typography.fontMedium14
        nameLabel.textColor = .white
        deleteView.isHidden = true
    }
    
    @IBAction func handleDeleteButton(_ sender: UIButton) {
        onTapDelete?()
    }
    
    func setContentForCell(data: SaveData, isShowDelete: Bool) {
        deleteView.isHidden = !isShowDelete
        nameLabel.text = data.name
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.imagePath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.15)),
            ])
    }
    
    func setContentForCell(data: MovieCommonInfomation) {
        nameLabel.text = data.originalTitle
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.posterPath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.15)),
            ])
    }
    
    func setContentForCell(data: TvShowCommonInfomation) {
        nameLabel.numberOfLines = 2
        nameLabel.text = data.originalName == nil ? data.originalTitle : data.originalName
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.posterPath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
    }
    
    func setContentForCell(data: KnownFor) {
        nameLabel.numberOfLines = 2
        nameLabel.text = data.originalTitle
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.posterPath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
    }
    
    func setContentForCell(data: MovieCast) {
        nameLabel.numberOfLines = 2
        nameLabel.text = data.originalTitle
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.posterPath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
    }
    
    func setContentForCell(data: Cast) {
        nameLabel.textAlignment = .left
        var castString = ""
        if let name = data.name, let nameCharacter = data.character {
            castString = "\(name)\n\(nameCharacter)"
            let attributedString = NSMutableAttributedString(string: castString, attributes: [NSAttributedString.Key.font: Typography.fontRegular10 ?? UIFont.systemFont(ofSize: 12),
                                                                                            NSAttributedString.Key.foregroundColor: UIColor(hex: "D9D9D9")])
            let nameRange = (castString as NSString).range(of: name)
            attributedString.setAttributes([NSAttributedString.Key.font: Typography.fontMedium12 ?? UIFont.systemFont(ofSize: 12),
                                            NSAttributedString.Key.foregroundColor: UIColor.white],
                                           range: nameRange)
            nameLabel.attributedText = attributedString
        }
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.profilePath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
    }
    
    func setContentForCell(data: Season) {
        var castString = ""
        if let seasonNumber = data.seasonNumber, let episodeCount = data.episodeCount {
            castString = "Season \(seasonNumber)\n\(episodeCount) Episodes"
            let attributedString = NSMutableAttributedString(string: castString, attributes: [NSAttributedString.Key.font: Typography.fontRegular10 ?? UIFont.systemFont(ofSize: 12),
                                                                                            NSAttributedString.Key.foregroundColor: UIColor(hex: "D9D9D9")])
            let nameRange = (castString as NSString).range(of: "Season \(seasonNumber)")
            attributedString.setAttributes([NSAttributedString.Key.font: Typography.fontMedium12 ?? UIFont.systemFont(ofSize: 12),
                                            NSAttributedString.Key.foregroundColor: UIColor.white],
                                           range: nameRange)
            nameLabel.attributedText = attributedString
        }
        imageView.kf.setImage(
            with: Utils.getUrlImage(path: data.posterPath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
    }
}
