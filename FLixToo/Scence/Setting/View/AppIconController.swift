//
//  AppIconController.swift
//  FLixToo
//
//  Created by buixuanhuy on 31/08/2024.
//

import UIKit
import Reusable

class AppIconController: BaseViewController {

    @IBOutlet weak var chooseAppIconLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var icon: [AppIconType] = [.original, .orange, .blackShade, .whitebeans, .purpleTheme, .yellowish]
    var currentSelect: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseAppIconLabel.font = Typography.fontSemibold16
        chooseAppIconLabel.textColor = UIColor(hex: "AAAAAA")
        title = "App Icon"
        tabBarController?.tabBar.isHidden = true
        collectionView.dataSource = self
        collectionView.register(cellType: AppIconCell.self)
        let layout = UICollectionViewFlowLayout()
        let padding = (Screen.width - 112*3) / 4
        layout.minimumLineSpacing = padding
        layout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
//        layout.minimumInteritemSpacing = padding
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        let itemWitdh = 112
        let itemHeight = 160
        layout.itemSize = CGSize(width: itemWitdh, height: itemHeight)
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func handleTapApply(_ sender: Any) {
        if let currentSelect = currentSelect {
            
            UIApplication.shared.setAlternateIconName(icon[currentSelect].getName()) { [weak self] error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Success! \(self?.icon[currentSelect].getName())")
                }
            }
        }
    }
}

extension AppIconController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: AppIconCell.self)
        cell.setContentForCell(data: icon[indexPath.row], showIconSelect: indexPath.row == currentSelect)
        return cell
    }
}

extension AppIconController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentSelect = indexPath.row
        collectionView.reloadData()
    }
}



extension AppIconController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.setting
}
