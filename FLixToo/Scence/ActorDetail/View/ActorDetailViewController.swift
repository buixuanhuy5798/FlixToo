//  
//  ActorDetailViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit

class ActorDetailViewController: UIViewController {

    var presenter: ActorDetailPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }
}

extension ActorDetailViewController:ActorDetailViewProtocol {
}
