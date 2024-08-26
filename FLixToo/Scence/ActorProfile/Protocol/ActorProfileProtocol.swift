//  
//  ActorProfileProtocol.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit

protocol ActorProfileViewProtocol: AnyObject {
}

protocol ActorProfilePresenterProtocol: AnyObject {
    var view: ActorProfileViewProtocol? { get set }
    var interactor: ActorProfileInteractorInputProtocol! { get set }
    var router: ActorProfileRouterProtocol! { get set }
    func onViewDidLoad()
}

protocol ActorProfileInteractorInputProtocol: AnyObject {
    var output: ActorProfileInteractorOutputProtocol? { get set }
}

protocol ActorProfileInteractorOutputProtocol: AnyObject {
}

protocol ActorProfileRouterProtocol: AnyObject {
    var viewController: ActorProfileViewController? { get set }
}
