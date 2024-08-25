//  
//  MovieDetailProtocol.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func updateMovieDetail(data: MovieDetail)
}

protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    var interactor: MovieDetailInteractorInputProtocol! { get set }
    var router: MovieDetailRouterProtocol! { get set }
    var id: Int? { get set }
    
    func onViewDidLoad()
}

protocol MovieDetailInteractorInputProtocol: AnyObject {
    var output: MovieDetailInteractorOutputProtocol? { get set }
    
    func getMovieDetail(id: String)
}

protocol MovieDetailInteractorOutputProtocol: AnyObject {
    func getMovieDetailSuccess(detail: MovieDetail)
    func getMovieDetailFail(message: String)
}

protocol MovieDetailRouterProtocol: AnyObject {
    var viewController: MovieDetailViewController? { get set }
}
