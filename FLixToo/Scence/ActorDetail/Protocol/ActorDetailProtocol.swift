//  
//  ActorDetailProtocol.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit

protocol ActorDetailViewProtocol: AnyObject {
}

protocol ActorDetailPresenterProtocol: AnyObject {
    var view: ActorDetailViewProtocol? { get set }
    var interactor: ActorDetailInteractorInputProtocol! { get set }
    var router: ActorDetailRouterProtocol! { get set }
    func onViewDidLoad()
}

protocol ActorDetailInteractorInputProtocol: AnyObject {
    var output: ActorDetailInteractorOutputProtocol? { get set }
}

protocol ActorDetailInteractorOutputProtocol: AnyObject {
}

protocol ActorDetailRouterProtocol: AnyObject {
    var viewController: ActorDetailViewController? { get set }
}
