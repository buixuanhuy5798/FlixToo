//
//  BounderListMovieCell.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit
import Reusable

class BounderListMovieCell: UITableViewCell, BaseCollectionViewInTableViewCell, NibReusable {

    @IBOutlet weak var iconNext: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var bottomConstraintLabel: NSLayoutConstraint!
    @IBOutlet weak var topConstraintLabel: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
        
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }

        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    var tapHeader: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(cellType: MovieProviderCell.self)
        collectionView.register(cellType: CategoryCell.self)
        collectionView.register(cellType: MoviePosterCell.self)
        collectionView.register(cellType: ActorCommonInfoCell.self)
        selectionStyle = .none
        titleLabel.textColor = .white
        titleLabel.font = Typography.fontSemibold18
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapLabel)))
    }
    
    @objc private func handleTapLabel() {
        tapHeader?()
    }
    
    private func setContentForCell(type: HomeCollectionSectionData) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        switch type {
        case .categories:
            let itemWitdh = (Screen.width - 48) / 2
            let itemHeight = itemWitdh * 96/158 
            layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        case .tredingMovies, .nowPlaying, .upcoming, .trendingShow, .upcomingShow, .topRatedShow, .freeMovieToWatch:
            let itemWitdh = (Screen.width - 48) / 3.2
            let itemHeight = itemWitdh * 194/102 + 16
            layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        case .movieProviders:
            layout.itemSize = CGSize(width: 60, height: 60)
        case .popularPeople:
            let itemWitdh = (Screen.width - 48) / 3.2
            let itemHeight = itemWitdh * 122/102
            layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        }
        collectionView.collectionViewLayout = layout
        switch type {
        case .freeMovieToWatch:
            titleLabel.isHidden = false
            titleLabel.text = "Free to watch"
            topConstraintLabel.constant = 16
            bottomConstraintLabel.constant = 16
            backgroundImageView.isHidden = false
            iconNext.isHidden = false
        default:
            titleLabel.text = ""
            titleLabel.isHidden = true
            topConstraintLabel.constant = 0
            bottomConstraintLabel.constant = 0
            backgroundImageView.isHidden = true
            iconNext.isHidden = true
        }
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, fowRow row: Int, type: HomeCollectionSectionData) {
        collectionView.dataSource = dataSourceDelegate
        collectionView.delegate = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
        setContentForCell(type: type)
    }
}
