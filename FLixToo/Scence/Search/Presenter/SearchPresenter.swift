//  
//  SearchPresenter.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

final class SearchPresenter: SearchPresenterProtocol {

    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorInputProtocol!
    var router: SearchRouterProtocol!
    
    func onViewDidLoad() {
    }
}

extension SearchPresenter:SearchInteractorOutputProtocol {
}
