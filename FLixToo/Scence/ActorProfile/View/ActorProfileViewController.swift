//  
//  ActorProfileViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit
import Reusable
import Kingfisher
import MASegmentedControl

class ActorProfileViewController: BaseViewController {

    @IBOutlet weak var segmentControl: MASegmentedControl! {
        didSet {
            
            segmentControl.itemsWithText = true
            segmentControl.fillEqually = true
            segmentControl.bottomLineThumbView = true
            segmentControl.setSegmentedWith(items: ["Known For", "Biography"])
            segmentControl.padding = 8
            segmentControl.textColor = .white
            segmentControl.titlesFont = Typography.fontSemibold16
            segmentControl.selectedTextColor = UIColor(hex: "1A8BFB")
            segmentControl.thumbViewColor = UIColor(hex: "1A8BFB")
        }
    }
    @IBOutlet weak var heightInfo: ActorInfoView!
    @IBOutlet weak var knowForView: ActorInfoView!
    @IBOutlet weak var bornInfoView: ActorInfoView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameActorLabel: UILabel!
    
    var presenter: ActorProfilePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        presenter.onViewDidLoad()
        title = "Actor's Profile"
        nameActorLabel.text = presenter.commonInfo?.name
        nameActorLabel.font = Typography.fontSemibold18
        nameActorLabel.textColor = .white
        profileImageView.kf.setImage(
            with: Utils.getUrlImage(path: presenter.commonInfo?.profilePath ?? ""),
            options: [
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.1)),
            ])
        bornInfoView.setContentView(title: "Born", content: "June 01 , 1986\nKingston upon Thames, United Kingdom")
        knowForView.setContentView(title: "Known For", content: presenter.commonInfo?.knowForDisplay ?? "")
        heightInfo.setContentView(title: "Height", content: "5'6", showLine: false)

        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.cornerRadius = profileImageView.frame.width / 2
    }
}

extension ActorProfileViewController:ActorProfileViewProtocol {
}

extension ActorProfileViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.actorProfile
}
