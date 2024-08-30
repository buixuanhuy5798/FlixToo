//
//  AddToLibraryControllerViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 30/8/24.
//

import UIKit
import PanModal
import Reusable

class AddToLibraryControllerViewController: UIViewController {

    @IBOutlet weak var bounderView: UIView!
    @IBOutlet weak var watchedLabel: UILabel!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var watchedButton: UIButton!
    @IBOutlet weak var watchLaterButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var dislikeLabel: UILabel!
    @IBOutlet weak var watchLaterLabel: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var item: SaveData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.font = Typography.fontBold18
        [watchedLabel, favLabel, watchLaterLabel, dislikeLabel].forEach {
            $0?.font = Typography.fontSemibold16
            $0?.textColor = UIColor(hex: "AAAAAA")
        }
        bounderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapBounderView)))
        bindView()
    }
    
    @objc func handleTapBounderView() {
        dismiss(animated: true)
    }
    
    func bindView() {
        guard let item = item else {
            return
        }
        if UserInfomation.favList.contains(where: { $0.id == item.id }) {
            favButton.setImage(UIImage(named: "ic_added"), for: .normal)
        } else {
            favButton.setImage(UIImage(named: "ic_add"), for: .normal)
        }
        
        if UserInfomation.watchLaterList.contains(where: { $0.id == item.id }) {
            watchLaterButton.setImage(UIImage(named: "ic_added"), for: .normal)
        } else {
            watchLaterButton.setImage(UIImage(named: "ic_add"), for: .normal)
        }
        
        if UserInfomation.watchedList.contains(where: { $0.id == item.id }) {
            watchedButton.setImage(UIImage(named: "ic_added"), for: .normal)
        } else {
            watchedButton.setImage(UIImage(named: "ic_add"), for: .normal)
        }
        
        if UserInfomation.dislikeList.contains(where: { $0.id == item.id }) {
            dislikeButton.setImage(UIImage(named: "ic_added"), for: .normal)
        } else {
            dislikeButton.setImage(UIImage(named: "ic_add"), for: .normal)
        }
    }
    
    @IBAction func handleTapDislike(_ sender: Any) {
        guard let item = item else {
            return
        }
        var fav = UserInfomation.dislikeList
        if let index = fav.firstIndex(where: { $0.id == item.id }) {
            fav.remove(at: index)
        } else {
            fav.append(item)
        }
        UserInfomation.dislikeList = fav
        bindView()
    }
    
    @IBAction func handleTapWatched(_ sender: Any) {
        guard let item = item else {
            return
        }
        var fav = UserInfomation.watchedList
        if let index = fav.firstIndex(where: { $0.id == item.id }) {
            fav.remove(at: index)
        } else {
            fav.append(item)
        }
        UserInfomation.watchedList = fav
        bindView()
    }
    
    @IBAction func handleTapWatchLater(_ sender: Any) {
        guard let item = item else {
            return
        }
        var fav = UserInfomation.watchLaterList
        if let index = fav.firstIndex(where: { $0.id == item.id }) {
            fav.remove(at: index)
        } else {
            fav.append(item)
        }
        UserInfomation.watchLaterList = fav
        bindView()
    }
    
    @IBAction func handleTapFav(_ sender: Any) {
        guard let item = item else {
            return
        }
        var fav = UserInfomation.favList
        if let index = fav.firstIndex(where: { $0.id == item.id }) {
            fav.remove(at: index)
        } else {
            fav.append(item)
        }
        UserInfomation.favList = fav
        bindView()
    }
}

extension AddToLibraryControllerViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.movieDetail
}

extension AddToLibraryControllerViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(Screen.height)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(Screen.height)
    }
    
    var showDragIndicator: Bool {
        return false
    }
    
    var cornerRadius: CGFloat {
        return 16
    }
    
    var allowsTapToDismiss: Bool {
        return true
    }
}
