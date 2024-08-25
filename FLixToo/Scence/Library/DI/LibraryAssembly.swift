//  
//  LibraryAssembly.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Swinject

class LibraryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(LibraryPresenterProtocol.self) { (resolver, viewController: LibraryViewController) in
            let presenter = LibraryPresenter()
            presenter.view = viewController
            // Interactor
            let interactor = LibraryInteractor()
            interactor.output = presenter
            presenter.interactor = interactor
            // Router
            let router = LibraryRouter()
            router.viewController = viewController
            presenter.router = router
            return presenter
        }
    }
}
