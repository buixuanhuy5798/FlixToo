//  
//  ActorProfileInteractor.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit
import RxSwift

final class ActorProfileInteractor: ActorProfileInteractorInputProtocol {
    weak var output: ActorProfileInteractorOutputProtocol?
    
    var repository: PeopleRepositoryType!
    private let disposebag = DisposeBag()
    
    func getActorDetail(id: Int) {
        repository.getDetailActorInfo(id: id).subscribe(onSuccess: { [weak self] response in
            self?.output?.getActorDetailSuccess(detail: response)
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.output?.getActorDetailFail(message: error.message ?? "")
            } else {
                self?.output?.getActorDetailFail(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
    }
    
    func getAllMovie(id: Int) {
        repository.getAllMovieByActor(id: id).subscribe(onSuccess: { [weak self] response in
            self?.output?.getAllMovieSuccess(moveid: response.cast ?? [])
        }, onFailure: { [weak self] error in
            if let error = error as? APIErrorResponse {
                self?.output?.getAllMovieFail(message: error.message ?? "")
            } else {
                self?.output?.getAllMovieFail(message: error.localizedDescription)
            }
        })
        .disposed(by: disposebag)
    }
}
