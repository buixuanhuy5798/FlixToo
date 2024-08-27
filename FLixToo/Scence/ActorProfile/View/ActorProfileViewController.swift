//  
//  ActorProfileViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit
import Reusable
import Kingfisher

class ActorProfileViewController: BaseViewController {

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
