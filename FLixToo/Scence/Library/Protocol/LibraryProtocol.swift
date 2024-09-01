//  
//  LibraryProtocol.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

protocol LibraryViewProtocol: AnyObject {
}

protocol LibraryPresenterProtocol: AnyObject {
    var view: LibraryViewProtocol? { get set }
    var interactor: LibraryInteractorInputProtocol! { get set }
    var router: LibraryRouterProtocol! { get set }
    var tags: [LibraryTag] { get set }
    var tagSelected: LibraryTag { get set }
    var favList: [SaveData] { get set }
    var watchLaterList: [SaveData] { get set }
    var watchedList: [SaveData] { get set }
    var dislikedList: [SaveData] { get set }
    func onViewDidLoad()
    func update()
}

protocol LibraryInteractorInputProtocol: AnyObject {
    var output: LibraryInteractorOutputProtocol? { get set }
}

protocol LibraryInteractorOutputProtocol: AnyObject {
}

protocol LibraryRouterProtocol: AnyObject {
    var viewController: LibraryViewController? { get set }
}
