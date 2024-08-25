//  
//  SettingProtocol.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

protocol SettingViewProtocol: AnyObject {
}

protocol SettingPresenterProtocol: AnyObject {
    var view: SettingViewProtocol? { get set }
    var interactor: SettingInteractorInputProtocol! { get set }
    var router: SettingRouterProtocol! { get set }
    func onViewDidLoad()
}

protocol SettingInteractorInputProtocol: AnyObject {
    var output: SettingInteractorOutputProtocol? { get set }
}

protocol SettingInteractorOutputProtocol: AnyObject {
}

protocol SettingRouterProtocol: AnyObject {
    var viewController: SettingViewController? { get set }
}
