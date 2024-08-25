//  
//  GenresPresenter.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit

final class GenresPresenter: GenresPresenterProtocol {

    weak var view: GenresViewProtocol?
    var interactor: GenresInteractorInputProtocol!
    var router: GenresRouterProtocol!
    
    func onViewDidLoad() {
    }
}

extension GenresPresenter:GenresInteractorOutputProtocol {
}
