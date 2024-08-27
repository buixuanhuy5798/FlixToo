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
}
