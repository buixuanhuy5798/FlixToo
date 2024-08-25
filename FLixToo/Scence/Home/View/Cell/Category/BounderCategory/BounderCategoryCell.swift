//
//  BounderCategoryCell.swift
//  FLixToo
//
//  Created by buixuanhuy on 24/08/2024.
//

import UIKit
import Reusable

protocol BaseCollectionViewInTableViewCell {
    var collectionViewOffset: CGFloat { get set }
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, fowRow row: Int)
}

class BounderCategoryCell: UITableViewCell, BaseCollectionViewInTableViewCell, NibReusable {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }

        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCollectionView()
        selectionStyle = .none
    }
    
    func setUpCollectionView() {
        collectionView.register(cellType: CategoryCell.self)
        let layout = UICollectionViewFlowLayout()
        let itemWitdh = (Screen.width - 48) / 2
        let itemHeight = itemWitdh * 96/158
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, fowRow row: Int) {
        collectionView.dataSource = dataSourceDelegate
        collectionView.delegate = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
}
