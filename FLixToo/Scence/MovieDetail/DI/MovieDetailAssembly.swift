//  
//  MovieDetailAssembly.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit
import Swinject

class MovieDetailAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MovieDetailPresenterProtocol.self) { (resolver, viewController: MovieDetailViewController, repository: MovieRepositoryType) in
            let presenter = MovieDetailPresenter()
            presenter.view = viewController
            // Interactor
            let interactor = MovieDetailInteractor()
            interactor.output = presenter
            interactor.repository = repository
            presenter.interactor = interactor
            // Router
            let router = MovieDetailRouter()
            router.viewController = viewController
            presenter.router = router
            return presenter
        }
    }
}
