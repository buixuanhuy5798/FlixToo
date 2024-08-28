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
                .upcomingShow([]),
                .nowPlaying([]),
                .topRatedShow([]),
                .popularPeople([]),
                .upcoming([]),
                .trendingShow([])
        ]
        interactor.getListMovieProviders(checkingType: .unchecked)
        interactor.getListPopularMovie(page: 1, checkingType: .unchecked)
        interactor.getListNowPlayingMovies(page: 1, checkingType: .unchecked)
        interactor.getListUpcomingMovies(page: 1, checkingType: .unchecked)
        interactor.getListPopularTVShow(page: 1, checkingType: .unchecked)
        interactor.getListUpcomingTvShow(page: 1, checkingType: .unchecked)
        interactor.getListTopRatedTVShow(page: 1, checkingType: .unchecked)
        interactor.getListPopularPeople(checkingType: .unchecked)
    }
    
    func openActorDetail(info: ActorCommonInfo) {
        router.openActorDetail(info: info)
    }
}

extension HomePresenter:HomeInteractorOutputProtocol {
    func getListPopularTVShowSuccess(data: [TvShowCommonInfomation]) {
        self.data[8] = .trendingShow(data)
        view?.reloadContent()
    }
    
    func getListPopularMovieSuccess(data: [MovieCommonInfomation]) {
        self.data[1] = .tredingMovies(data)
        view?.reloadContent()
    }
    
    func getListUpcomingMoviesSuccess(data: [MovieCommonInfomation]) {
        self.data[7] = .upcoming(data)
        view?.reloadContent()
    }
    
    func getListNowPlayingMoviesSuccess(data: [MovieCommonInfomation]) {
        self.data[4] = .nowPlaying(data)
        view?.reloadContent()
    }
    
    func getListMovieProvidersSuccess(data: [MovieProvider]) {
        self.data[2] = .movieProviders(data)
        view?.reloadContent()
    }
    
    func getListPopularPeople(data: [ActorCommonInfo]) {
        self.data[6] = .popularPeople(data)
        view?.reloadContent()
    }
    
    func getListUpcomingTVShowSuccess(data: [TvShowCommonInfomation]) {
        self.data[3] = .upcomingShow(data)
        view?.reloadContent()
    }
    
    func getListTopRatedTVShowSuccess(data: [TvShowCommonInfomation]) {
        self.data[5] = .topRatedShow(data)
        view?.reloadContent()
    }
}
