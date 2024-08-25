//  
//  HomePresenter.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

final class HomePresenter: HomePresenterProtocol {

    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol!
    var router: HomeRouterProtocol!
    var data = [HomeCollectionSectionData]()
    
    func onViewDidLoad() {
        data = [.categories([.movie, .show]),
                .tredingMovies([]),
                .movieProviders([]),
                .nowPlaying([]),
                .upcoming([])]
        interactor.getListMovieProviders(checkingType: .unchecked)
        interactor.getListPopularMovie(page: 1, checkingType: .checked)
        interactor.getListNowPlayingMovies(page: 1, checkingType: .checked)
        interactor.getListUpcomingMovies(page: 1, checkingType: .checked)
    }
}

extension HomePresenter:HomeInteractorOutputProtocol {    
    func getListPopularMovieSuccess(data: [MovieCommonInfomation]) {
        self.data[1] = .tredingMovies(data)
        view?.reloadContent()
    }
    
    func getListUpcomingMoviesSuccess(data: [MovieCommonInfomation]) {
        self.data[4] = .upcoming(data)
        view?.reloadContent()
    }
    
    func getListNowPlayingMoviesSuccess(data: [MovieCommonInfomation]) {
        self.data[3] = .nowPlaying(data)
        view?.reloadContent()
    }
    
    func getListMovieProvidersSuccess(data: [MovieProvider]) {
        self.data[2] = .movieProviders(data)
        view?.reloadContent()
    }
}
