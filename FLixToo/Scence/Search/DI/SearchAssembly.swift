//  
//  SearchAssembly.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Swinject

class SearchAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SearchPresenterProtocol.self) { (resolver, viewController: SearchViewController) in
            let presenter = SearchPresenter()
            presenter.view = viewController
            // Interactor
            let interactor = SearchInteractor()
            interactor.output = presenter
            presenter.interactor = interactor
            // Router
            let router = SearchRouter()
            router.viewController = viewController
            presenter.router = router
            return presenter
        }
    }
}
