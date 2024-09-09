//  
//  ActorProfilePresenter.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit

final class ActorProfilePresenter: ActorProfilePresenterProtocol {

    weak var view: ActorProfileViewProtocol?
    var interactor: ActorProfileInteractorInputProtocol!
    var router: ActorProfileRouterProtocol!
    var commonInfo: ActorCommonInfo?
    var listMovie = [MovieCast]()
    
    func onViewDidLoad() {
        guard let id = commonInfo?.id else { return }
        interactor.getActorDetail(id: id)
        interactor.getAllMovie(id: id)
    }
}

extension ActorProfilePresenter:ActorProfileInteractorOutputProtocol {
    func getActorDetailSuccess(detail: ActorDetailInfo) {
        view?.updateActorDetail(data: detail)
    }
    
    func getActorDetailFail(message: String) {
        view?.showError(message: message)
    }
    
    func getAllMovieSuccess(moveid: [MovieCast]) {
        listMovie = moveid
        view?.updateKnowfor()
    }
    
    func getAllMovieFail(message: String) {
        view?.showError(message: message)
    }
}
