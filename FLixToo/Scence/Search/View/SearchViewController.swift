//  
//  SearchViewController.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Reusable

class SearchViewController: BaseViewController {

    var presenter: SearchPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
        title = "Search"
        showBackButton = false
    }
}

extension SearchViewController:SearchViewProtocol {
}

extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.search
}
