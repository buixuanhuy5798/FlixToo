//  
//  CinemasProtocol.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

protocol CinemasViewProtocol: AnyObject {
}

protocol CinemasPresenterProtocol: AnyObject {
    var view: CinemasViewProtocol? { get set }
    var interactor: CinemasInteractorInputProtocol! { get set }
    var router: CinemasRouterProtocol! { get set }
    func onViewDidLoad()
}

protocol CinemasInteractorInputProtocol: AnyObject {
    var output: CinemasInteractorOutputProtocol? { get set }
}

protocol CinemasInteractorOutputProtocol: AnyObject {
}

protocol CinemasRouterProtocol: AnyObject {
    var viewController: CinemasViewController? { get set }
}
