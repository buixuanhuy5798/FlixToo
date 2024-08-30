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
    var favList: [SaveData] = UserInfomation.favList
    var watchLaterList: [SaveData] = UserInfomation.watchLaterList
    var watchedList: [SaveData] = UserInfomation.watchedList
    var dislikedList: [SaveData] = UserInfomation.dislikeList
    
    func onViewDidLoad() {
    }
}

extension LibraryPresenter:LibraryInteractorOutputProtocol {
}
