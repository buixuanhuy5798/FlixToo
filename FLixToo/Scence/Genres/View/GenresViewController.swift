//  
//  GenresViewController.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit

class GenresViewController: UIViewController {

    var presenter: GenresPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.onViewDidLoad()
    }
}

extension GenresViewController:GenresViewProtocol {
}
