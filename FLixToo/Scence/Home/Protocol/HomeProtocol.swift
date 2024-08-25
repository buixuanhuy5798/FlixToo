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
}

protocol HomeInteractorInputProtocol: AnyObject {
    var output: HomeInteractorOutputProtocol? { get set }
    
    func getListPopularMovie(page: Int, checkingType: CheckingType)
    func getListUpcomingMovies(page: Int, checkingType: CheckingType)
    func getListNowPlayingMovies(page: Int, checkingType: CheckingType)
    func getListMovieProviders(checkingType: CheckingType)
}

protocol HomeInteractorOutputProtocol: AnyObject {
    func getListPopularMovieSuccess(data: [MovieCommonInfomation])
    func getListUpcomingMoviesSuccess(data: [MovieCommonInfomation])
    func getListNowPlayingMoviesSuccess(data: [MovieCommonInfomation])
    func getListMovieProvidersSuccess(data: [MovieProvider])
}

protocol HomeRouterProtocol: AnyObject {
    var viewController: HomeViewController? { get set }
}
