//  
//  LibraryViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable

class LibraryViewController: BaseViewController {

    var presenter: LibraryPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        title = "Library"
        showBackButton = false
    }
}

extension LibraryViewController:LibraryViewProtocol {
}

extension LibraryViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.library
}
