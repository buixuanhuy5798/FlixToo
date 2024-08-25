//  
//  GenresAssembly.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit
import Swinject

class GenresAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GenresPresenterProtocol.self) { (resolver, viewController: GenresViewController) in
            let presenter = GenresPresenter()
            presenter.view = viewController
            // Interactor
            let interactor = GenresInteractor()
            interactor.output = presenter
            presenter.interactor = interactor
            // Router
            let router = GenresRouter()
            router.viewController = viewController
            presenter.router = router
            return presenter
        }
    }
}
