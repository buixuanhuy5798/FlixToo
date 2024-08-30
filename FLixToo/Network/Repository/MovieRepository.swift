//
//  MovieRepository.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import Foundation
import RxSwift

struct BaseResponse<T: Codable>: Codable {
    var results: T?
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct BasePageResponse<T: Codable>: Codable {
    var page: Int?
    var results: T?
    var totalPage: Int?
    var totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPage = "total_pages"
        case totalResults = "total_results"
    }
}

protocol MovieRepositoryType {
    func getListPopularMovie(page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>>
    func getListUpcomingMovies(page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>>
    func getListNowPlayingMovies(page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>>
    func getListMovieProviders(checking: CheckingType) -> Single<BaseResponse<[MovieProvider]>>
    func getMovieDetail(id: String) -> Single<MovieDetail>
    
    func getListPopularTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>>
    func getListUpcomingTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>>
    func getListTopRatedTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>>
    
    func getSimilarMove(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>>
    func getMovieCredit(id: Int) -> Single<MovieCredit>
    func getBackdropImages(id: Int) -> Single<BackdropsMovie>
    func getReview(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[Comment]>>
}

struct MovieRepository: MovieRepositoryType {
    let api: APIService
    
    init(_ api: APIService) {
        self.api = api
    }
    
    func getListPopularMovie(page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .getListPopularMovie(page: page), checking: checking)
    }
    
    func getListUpcomingMovies(page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .getListUpcomingMovies(page: page), checking: checking)
    }
    
    func getListNowPlayingMovies(page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .getListNowPlayingMovies(page: page), checking: checking)
    }
    
    func getListMovieProviders(checking: CheckingType) -> Single<BaseResponse<[MovieProvider]>> {
        return api.request(router: .getListMovieProviders, checking: checking)
    }
    
    func getMovieDetail(id: String) -> Single<MovieDetail> {
        return api.request(router: .getMovieDetail(id: id), checking: .checked)
    }
    
    func getListPopularTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>> {
        return api.request(router: .getListTVPopular(page: page), checking: checking)
    }
    
    func getListUpcomingTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>> {
        return api.request(router: .getListUpcomingTVShow(page: page), checking: checking)
    }
    
    func getListTopRatedTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>> {
        return api.request(router: .getListTopRatedTVShow(page: page), checking: checking)
    }
    
    func getMovieCredit(id: Int) -> Single<MovieCredit> {
        return api.request(router: .getMovieCredit(id: id), checking: .unchecked)
    }
    
    func getSimilarMove(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .getSimilarMovie(id: id, page: page), checking: checking)
    }
    
    func getBackdropImages(id: Int) -> Single<BackdropsMovie> {
        return api.request(router: .getAllBackdrops(id: id), checking: .unchecked)
    }
    
    func getMoviesByGenre(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .getMoviesByGenre(id: id, page: page), checking: checking)
    }
    
    func getShowsByGenre(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>> {
        return api.request(router: .getMoviesByGenre(id: id, page: page), checking: checking)
    }
    
    func getReview(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[Comment]>> {
        return api.request(router: .getReview(id: id, page: page), checking: checking)
    }
}
