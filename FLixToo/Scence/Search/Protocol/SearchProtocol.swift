//  
//  SearchProtocol.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
}

protocol SearchPresenterProtocol: AnyObject {
    var view: SearchViewProtocol? { get set }
    var interactor: SearchInteractorInputProtocol! { get set }
    var router: SearchRouterProtocol! { get set }
    func onViewDidLoad()
}

protocol SearchInteractorInputProtocol: AnyObject {
    var output: SearchInteractorOutputProtocol? { get set }
}

protocol SearchInteractorOutputProtocol: AnyObject {
}

protocol SearchRouterProtocol: AnyObject {
    var viewController: SearchViewController? { get set }
}
