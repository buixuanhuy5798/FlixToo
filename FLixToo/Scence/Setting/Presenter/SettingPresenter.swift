//  
//  SettingPresenter.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

final class SettingPresenter: SettingPresenterProtocol {

    weak var view: SettingViewProtocol?
    var interactor: SettingInteractorInputProtocol!
    var router: SettingRouterProtocol!
    
    func onViewDidLoad() {
    }
}

extension SettingPresenter:SettingInteractorOutputProtocol {
}
