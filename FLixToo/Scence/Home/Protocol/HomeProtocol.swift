//  
//  HomeProtocol.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func reloadContent()
}

protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol! { get set }
    var router: HomeRouterProtocol! { get set }
    var data: [HomeCollectionSectionData] { get set }
    
    func onViewDidLoad()
    func openActorDetail(info: ActorCommonInfo)
}

protocol HomeInteractorInputProtocol: AnyObject {
    var output: HomeInteractorOutputProtocol? { get set }
    
    func getListPopularMovie(page: Int, checkingType: CheckingType)
    func getListUpcomingMovies(page: Int, checkingType: CheckingType)
    func getListNowPlayingMovies(page: Int, checkingType: CheckingType)
    func getListMovieProviders(checkingType: CheckingType)
    func getListPopularPeople(checkingType: CheckingType)
    func getListPopularTVShow(page: Int, checkingType: CheckingType)
    func getListUpcomingTvShow(page: Int, checkingType: CheckingType)
    func getListTopRatedTVShow(page: Int, checkingType: CheckingType)
    func getListFreeMovieToWatch(page: Int, checkingType: CheckingType)
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func getListPopularMovieSuccess(data: [MovieCommonInfomation])
    func getListUpcomingMoviesSuccess(data: [MovieCommonInfomation])
    func getListNowPlayingMoviesSuccess(data: [MovieCommonInfomation])
    func getListMovieProvidersSuccess(data: [MovieProvider])
    func getListPopularPeople(data: [ActorCommonInfo])
    func getListPopularTVShowSuccess(data: [TvShowCommonInfomation])
    func getListUpcomingTVShowSuccess(data: [TvShowCommonInfomation])
    func getListTopRatedTVShowSuccess(data: [TvShowCommonInfomation])
    func getListFreeMovieToWatchSuccess(data: [MovieCommonInfomation])
}

protocol HomeRouterProtocol: AnyObject {
    var viewController: HomeViewController? { get set }
    
    func openActorDetail(info: ActorCommonInfo)
}
