//  
//  GenresProtocol.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit

protocol GenresViewProtocol: AnyObject {
}

protocol GenresPresenterProtocol: AnyObject {
    var view: GenresViewProtocol? { get set }
    var interactor: GenresInteractorInputProtocol! { get set }
    var router: GenresRouterProtocol! { get set }
    func onViewDidLoad()
}

protocol GenresInteractorInputProtocol: AnyObject {
    var output: GenresInteractorOutputProtocol? { get set }
}

protocol GenresInteractorOutputProtocol: AnyObject {
}

protocol GenresRouterProtocol: AnyObject {
    var viewController: GenresViewController? { get set }
}
