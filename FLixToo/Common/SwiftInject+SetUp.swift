//
//  SwiftInject+SetUp.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    public static func setup() {
        defaultContainer.register(APIService.self) { _ in
            return APIService()
        }.inObjectScope(.container)
        
        defaultContainer.register(MovieRepositoryType.self) { r in
            let api = r.resolve(APIService.self)!
            return MovieRepository(api)
        }.inObjectScope(.container)
        
        defaultContainer.register(PeopleRepositoryType.self) { r in
            let api = r.resolve(APIService.self)!
            return PeopleRepository(api)
        }.inObjectScope(.container)
        
        defaultContainer.storyboardInitCompleted(HomeViewController.self) { r, c in
            let assembler = Assembler([HomeAssembly()])
            let repository = r.resolve(MovieRepositoryType.self)!
            let peopleRepository = r.resolve(PeopleRepositoryType.self)!
            c.presenter = assembler.resolver.resolve(HomePresenterProtocol.self, arguments: c, repository, peopleRepository)
        }
        
        defaultContainer.storyboardInitCompleted(MovieDetailViewController.self) { r, c in
            let assembler = Assembler([MovieDetailAssembly()])
            let repository = r.resolve(MovieRepositoryType.self)!
            c.presenter = assembler.resolver.resolve(MovieDetailPresenterProtocol.self, arguments: c, repository)
        }
        
        defaultContainer.storyboardInitCompleted(SearchViewController.self) { _, c in
            let assembler = Assembler([SearchAssembly()])
            c.presenter = assembler.resolver.resolve(SearchPresenterProtocol.self, argument: c)
        }
        
        defaultContainer.storyboardInitCompleted(CinemasViewController.self) { _, c in
            let assembler = Assembler([CinemasAssembly()])
            c.presenter = assembler.resolver.resolve(CinemasPresenterProtocol.self, argument: c)
        }
        
        defaultContainer.storyboardInitCompleted(LibraryViewController.self) { _, c in
            let assembler = Assembler([LibraryAssembly()])
            c.presenter = assembler.resolver.resolve(LibraryPresenterProtocol.self, argument: c)
        }
        
        defaultContainer.storyboardInitCompleted(SettingViewController.self) { _, c in
            let assembler = Assembler([SettingAssembly()])
            c.presenter = assembler.resolver.resolve(SettingPresenterProtocol.self, argument: c)
        }
    }
}
