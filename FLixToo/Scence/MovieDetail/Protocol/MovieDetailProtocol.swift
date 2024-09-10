//  
//  MovieDetailProtocol.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func updateMovieDetail(data: MovieDetail)
    func updateListCredit(credit: MovieCredit)
    func updateSimilarMovies(movies: [MovieCommonInfomation])
    func updateBackdrops(backdrop: BackdropsMovie)
    func updateComment(comment: [Comment])
    func updateStreamOn(data: MovieStreamOn)
    func showError(message: String)
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
    func getMovieCredit(id: Int)
    func getSimilarMovie(id: Int, page: Int, checking: CheckingType)
    func getAllBackdrops(id: Int)
    func getComment(id: Int, page: Int, checking: CheckingType)
    func getMovieStreamOn(id: Int)
}

protocol MovieDetailInteractorOutputProtocol: AnyObject {
    func getMovieDetailSuccess(detail: MovieDetail)
    func getMovieDetailFail(message: String)
    func getMovieCreditSuccess(credit: MovieCredit)
    func getMovieCreditFail(message: String)
    func getSimilarMovieSuccess(movies: [MovieCommonInfomation])
    func getSimilarMovieFail(message: String)
    func getAllBackdropSuccess(backdrop: BackdropsMovie)
    func getAllBackdropFail(message: String)
    func getCommentSuccess(comment: [Comment])
    func getTvShowStreamOnSuccess(data: MovieStreamOn)
    func getTvShowStreamOnFail(message: String)
}

protocol MovieDetailRouterProtocol: AnyObject {
    var viewController: MovieDetailViewController? { get set }
}
