//  
//  CinemasPresenter.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

final class CinemasPresenter: CinemasPresenterProtocol {

    weak var view: CinemasViewProtocol?
    var interactor: CinemasInteractorInputProtocol!
    var router: CinemasRouterProtocol!
    
    func onViewDidLoad() {
    }
}

extension CinemasPresenter:CinemasInteractorOutputProtocol {
}
