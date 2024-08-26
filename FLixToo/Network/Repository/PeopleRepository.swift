//
//  PeopleRepository.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import Foundation
import RxSwift

protocol PeopleRepositoryType {
    func getListPopularPeople(checking: CheckingType) -> Single<BaseResponse<[ActorCommonInfo]>>
}

struct PeopleRepository: PeopleRepositoryType {
    let api: APIService
    
    init(_ api: APIService) {
        self.api = api
    }
    
    func getListPopularPeople(checking: CheckingType) -> Single<BaseResponse<[ActorCommonInfo]>> {
        return api.request(router: .getPopularPeople, checking: checking)
    }
}
