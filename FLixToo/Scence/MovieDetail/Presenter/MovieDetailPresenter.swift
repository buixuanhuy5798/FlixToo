//  
//  MovieDetailPresenter.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit

final class MovieDetailPresenter: MovieDetailPresenterProtocol {

    weak var view: MovieDetailViewProtocol?
    var interactor: MovieDetailInteractorInputProtocol!
    var router: MovieDetailRouterProtocol!
    var id: Int?
    
    func onViewDidLoad() {
        guard let id = id else { return }
        interactor.getMovieDetail(id: "\(id)")
    }
}

extension MovieDetailPresenter:MovieDetailInteractorOutputProtocol {
    func getMovieDetailSuccess(detail: MovieDetail) {
        view?.updateMovieDetail(data: detail)
    }
    
    func getMovieDetailFail(message: String) {
        
    }
}
