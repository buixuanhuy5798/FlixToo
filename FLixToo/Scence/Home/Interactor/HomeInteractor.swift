//  
//  HomeInteractor.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit
import RxSwift

final class HomeInteractor: HomeInteractorInputProtocol {
    weak var output: HomeInteractorOutputProtocol?
    
    var repository: MovieRepositoryType!
    var peopleRepository: PeopleRepositoryType!
    
    private let disposebag = DisposeBag()
    
    func getListPopularMovie(page: Int, checkingType: CheckingType) {
        repository.getListPopularMovie(page: page, checking: checkingType).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getListPopularMovieSuccess(data: results)
        })
        .disposed(by: disposebag)
    }
    
    func getListUpcomingMovies(page: Int, checkingType: CheckingType) {
        repository.getListUpcomingMovies(page: page, checking: checkingType).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getListUpcomingMoviesSuccess(data: results)
        })
        .disposed(by: disposebag)
    }
    
    func getListNowPlayingMovies(page: Int, checkingType: CheckingType) {
        repository.getListNowPlayingMovies(page: page, checking: checkingType).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getListNowPlayingMoviesSuccess(data: results)
        })
        .disposed(by: disposebag)
    }
    
    func getListMovieProviders(checkingType: CheckingType) {
        repository.getListMovieProviders(checking: checkingType).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getListMovieProvidersSuccess(data: results)
        })
        .disposed(by: disposebag)
    }
    
    func getListPopularPeople(checkingType: CheckingType) {
        peopleRepository.getListPopularPeople(checking: checkingType).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getListPopularPeople(data: results)
        })
        .disposed(by: disposebag)
    }
    
    func getListPopularTVShow(page: Int, checkingType: CheckingType) {
        repository.getListPopularTVShow(page: page, checking: checkingType).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getListPopularTVShowSuccess(data: results)
        })
        .disposed(by: disposebag)
    }
    
    func getListUpcomingTvShow(page: Int, checkingType: CheckingType) {
        repository.getListUpcomingTVShow(page: page, checking: checkingType).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getListUpcomingTVShowSuccess(data: results)
        })
        .disposed(by: disposebag)
    }
    
    func getListTopRatedTVShow(page: Int, checkingType: CheckingType) {
        repository.getListTopRatedTVShow(page: page, checking: checkingType).subscribe(onSuccess: { [weak self] response in
            guard let results = response.results else {
                return
            }
            self?.output?.getListTopRatedTVShowSuccess(data: results)
        })
        .disposed(by: disposebag)
    }
}
