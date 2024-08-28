//  
//  ActorProfileProtocol.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit

protocol ActorProfileViewProtocol: AnyObject {
    func updateActorDetail(data: ActorDetailInfo)
    func showError(message: String)
}

protocol ActorProfilePresenterProtocol: AnyObject {
    var view: ActorProfileViewProtocol? { get set }
    var interactor: ActorProfileInteractorInputProtocol! { get set }
    var router: ActorProfileRouterProtocol! { get set }
    var commonInfo: ActorCommonInfo? { get set }
    
    func onViewDidLoad()
}

protocol ActorProfileInteractorInputProtocol: AnyObject {
    var output: ActorProfileInteractorOutputProtocol? { get set }
    
    func getActorDetail(id: Int)
}

protocol ActorProfileInteractorOutputProtocol: AnyObject {
    func getActorDetailSuccess(detail: ActorDetailInfo)
    func getActorDetailFail(message: String)
}

protocol ActorProfileRouterProtocol: AnyObject {
    var viewController: ActorProfileViewController? { get set }
}
