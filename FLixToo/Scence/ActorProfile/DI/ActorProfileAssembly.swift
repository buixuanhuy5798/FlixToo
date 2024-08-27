//  
//  ActorProfileAssembly.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit
import Swinject

class ActorProfileAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ActorProfilePresenterProtocol.self) { (resolver, viewController: ActorProfileViewController, repository: PeopleRepositoryType) in
            let presenter = ActorProfilePresenter()
            presenter.view = viewController
            // Interactor
            let interactor = ActorProfileInteractor()
            interactor.output = presenter
            interactor.repository = repository
            presenter.interactor = interactor
            // Router
            let router = ActorProfileRouter()
            router.viewController = viewController
            presenter.router = router
            return presenter
        }
    }
}
