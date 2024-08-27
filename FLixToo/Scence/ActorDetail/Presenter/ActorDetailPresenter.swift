//  
//  ActorDetailPresenter.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit

final class ActorDetailPresenter: ActorDetailPresenterProtocol {

    weak var view: ActorDetailViewProtocol?
    var interactor: ActorDetailInteractorInputProtocol!
    var router: ActorDetailRouterProtocol!
    
    func onViewDidLoad() {
    }
}

extension ActorDetailPresenter:ActorDetailInteractorOutputProtocol {
}
