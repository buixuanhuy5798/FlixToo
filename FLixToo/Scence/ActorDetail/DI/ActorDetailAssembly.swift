//  
//  ActorDetailAssembly.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit
import Swinject

class ActorDetailAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ActorDetailPresenterProtocol.self) { (resolver, viewController: ActorDetailViewController) in
            let presenter = ActorDetailPresenter()
            presenter.view = viewController
            // Interactor
            let interactor = ActorDetailInteractor()
            interactor.output = presenter
            presenter.interactor = interactor
            // Router
            let router = ActorDetailRouter()
            router.viewController = viewController
            presenter.router = router
            return presenter
        }
    }
}
