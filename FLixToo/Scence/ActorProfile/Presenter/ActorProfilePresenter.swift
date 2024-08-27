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
    
    func onViewDidLoad() {
    }
}

extension ActorProfilePresenter:ActorProfileInteractorOutputProtocol {
}
