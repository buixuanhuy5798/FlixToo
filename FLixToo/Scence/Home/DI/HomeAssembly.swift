//  
//  HomeAssembly.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Swinject

class HomeAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomePresenterProtocol.self) { (resolver, viewController: HomeViewController, repository: MovieRepositoryType) in
            let presenter = HomePresenter()
            presenter.view = viewController
            // Interactor
            let interactor = HomeInteractor()
            interactor.repository = repository
            interactor.output = presenter
            presenter.interactor = interactor
            // Router
            let router = HomeRouter()
            router.viewController = viewController
            presenter.router = router
            return presenter
        }
    }
}
