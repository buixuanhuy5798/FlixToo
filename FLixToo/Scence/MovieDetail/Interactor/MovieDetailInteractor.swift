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
}
