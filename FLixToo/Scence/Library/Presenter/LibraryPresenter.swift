//  
//  LibraryPresenter.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

final class LibraryPresenter: LibraryPresenterProtocol {

    weak var view: LibraryViewProtocol?
    var interactor: LibraryInteractorInputProtocol!
    var router: LibraryRouterProtocol!
    
    var tags: [LibraryTag] = LibraryTag.allCases
    var tagSelected: LibraryTag = .favorite
    
    func onViewDidLoad() {
    }
}

extension LibraryPresenter:LibraryInteractorOutputProtocol {
}
