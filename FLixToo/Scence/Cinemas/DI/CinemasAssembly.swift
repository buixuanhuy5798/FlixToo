//  
//  CinemasAssembly.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Swinject

class CinemasAssembly: Assembly {
    func assemble(container: Container) {
        container.register(CinemasPresenterProtocol.self) { (resolver, viewController: CinemasViewController) in
            let presenter = CinemasPresenter()
            presenter.view = viewController
            // Interactor
            let interactor = CinemasInteractor()
            interactor.output = presenter
            presenter.interactor = interactor
            // Router
            let router = CinemasRouter()
            router.viewController = viewController
            presenter.router = router
            return presenter
        }
    }
}
