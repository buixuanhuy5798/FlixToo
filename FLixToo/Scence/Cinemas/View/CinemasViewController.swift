//  
//  CinemasViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable

class CinemasViewController: BaseViewController {

    var presenter: CinemasPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        title = "Cinemas"
        showBackButton = false
    }
}

extension CinemasViewController:CinemasViewProtocol {
}

extension CinemasViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.cinemas
}
