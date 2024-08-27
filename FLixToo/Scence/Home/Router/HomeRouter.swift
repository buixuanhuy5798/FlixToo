//  
//  HomeRouter.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

final class HomeRouter: HomeRouterProtocol {
    weak var viewController: HomeViewController?
    
    func openActorDetail(info: ActorCommonInfo) {
        let vc = ActorProfileViewController.instantiate()
        vc.presenter.commonInfo = info
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
