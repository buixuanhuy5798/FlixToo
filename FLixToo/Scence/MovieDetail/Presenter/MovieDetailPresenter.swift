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
        interactor.getMovieCredit(id: id)
        interactor.getSimilarMovie(id: id, page: 1, checking: .unchecked)
        interactor.getAllBackdrops(id: id)
    }
}

extension MovieDetailPresenter:MovieDetailInteractorOutputProtocol {
    func getMovieDetailSuccess(detail: MovieDetail) {
        view?.updateMovieDetail(data: detail)
    }
    
    func getMovieDetailFail(message: String) {
        view?.showError(message: message)
    }
    
    func getMovieCreditSuccess(credit: MovieCredit) {
        view?.updateListCredit(credit: credit)
    }
    
    func getMovieCreditFail(message: String) {
        view?.showError(message: message)
    }
    
    func getSimilarMovieSuccess(movies: [MovieCommonInfomation]) {
        view?.updateSimilarMovies(movies: movies)
    }
    
    func getSimilarMovieFail(message: String) {
        view?.showError(message: message)
    }
    
    func getAllBackdropSuccess(backdrop: BackdropsMovie) {
        view?.updateBackdrops(backdrop: backdrop)
    }
    
    func getAllBackdropFail(message: String) {
        view?.showError(message: message)
    }
}
