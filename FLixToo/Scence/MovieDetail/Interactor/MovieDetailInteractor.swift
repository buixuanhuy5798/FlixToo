//  
//  MovieDetailInteractor.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import UIKit
import RxSwift

final class MovieDetailInteractor: MovieDetailInteractorInputProtocol {
    weak var output: MovieDetailInteractorOutputProtocol?
    var repository: MovieRepositoryType!
    
    private let disposebag = DisposeBag()
    
    
    func getMovieDetail(id: String) {
        repository.getMovieDetail(id: id).subscribe(onSuccess: { [weak self] response in
            self?.output?.getMovieDetailSuccess(detail: response)
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.output?.getMovieDetailFail(message: error.message ?? "")
            } else {
                self?.output?.getMovieDetailFail(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
    }
    
    func getMovieCredit(id: Int) {
        repository.getMovieCredit(id: id).subscribe(onSuccess: { [weak self] response in
            self?.output?.getMovieCreditSuccess(credit: response)
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.output?.getMovieCreditFail(message: error.message ?? "")
            } else {
                self?.output?.getMovieCreditFail(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
    }
    
    func getSimilarMovie(id: Int, page: Int, checking: CheckingType) {
        repository.getSimilarMove(id: id, page: page, checking: checking).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getSimilarMovieSuccess(movies: results)
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.output?.getSimilarMovieFail(message: error.message ?? "")
            } else {
                self?.output?.getSimilarMovieFail(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
    }
    
    func getAllBackdrops(id: Int) {
        repository.getBackdropImages(id: id, type: .movie).subscribe(onSuccess: { [weak self] response in
            self?.output?.getAllBackdropSuccess(backdrop: response)
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.output?.getAllBackdropFail(message: error.message ?? "")
            } else {
                self?.output?.getAllBackdropFail(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
    }
    
    func getComment(id: Int, page: Int, checking: CheckingType) {
        repository.getReview(id: id, page: page, checking: checking, type: .movie).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getCommentSuccess(comment: results)
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.output?.getSimilarMovieFail(message: error.message ?? "")
            } else {
                self?.output?.getSimilarMovieFail(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
    }
    
    func getMovieStreamOn(id: Int) {
        repository.getMovieStreamOn(id: id).subscribe(onSuccess: { [weak self] response in
            self?.output?.getTvShowStreamOnSuccess(data: response)
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.output?.getTvShowStreamOnFail(message: error.message ?? "")
            } else {
                self?.output?.getTvShowStreamOnFail(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
    }
}
