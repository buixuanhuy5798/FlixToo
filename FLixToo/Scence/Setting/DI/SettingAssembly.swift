//  
//  SettingAssembly.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import Swinject

class SettingAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SettingPresenterProtocol.self) { (resolver, viewController: SettingViewController) in
            let presenter = SettingPresenter()
            presenter.view = viewController
            // Interactor
            let interactor = SettingInteractor()
            interactor.output = presenter
            presenter.interactor = interactor
            // Router
            let router = SettingRouter()
            router.viewController = viewController
            presenter.router = router
            return presenter
        }
    }
}
