//  
//  ActorProfileViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit

class ActorProfileViewController: UIViewController {

    var presenter: ActorProfilePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }
}

extension ActorProfileViewController:ActorProfileViewProtocol {
}
