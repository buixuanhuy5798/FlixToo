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
    func getListFreeMovieToWatch(page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>>

    func getListPopularTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>>
    func getListUpcomingTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>>
    func getListTopRatedTVShow(page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>>
    
    func getSimilarMove(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>>
    func getMovieCredit(id: Int) -> Single<MovieCredit>
    func getBackdropImages(id: Int, type: HomeCategoryOption) -> Single<BackdropsMovie>
    func getReview(id: Int, page: Int, checking: CheckingType, type: HomeCategoryOption) -> Single<BasePageResponse<[Comment]>> 
    func getVideo(id: Int, type: HomeCategoryOption) -> Single<BaseResponse<[MovieVideo]>>
    func getShowDetail(id: Int) -> Single<ShowDetail>
    func getShowCredit(id: Int) -> Single<MovieCredit>
    func getSimilarShow(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>>
    func getMoviesByProvider(id: Int, sortBy: String, page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>>
    func getTvShowStreamOn(id: Int) -> Single<MovieStreamOn>
    func getMovieStreamOn(id: Int) -> Single<MovieStreamOn>
    func searchMovies(keyword: String, page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>>
}

struct MovieRepository: MovieRepositoryType {
    let api: APIService
    
    init(_ api: APIService) {
        self.api = api
    }
    
    func searchMovies(keyword: String, page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>> {
        return api.request(router: .searchMovies(keyword: keyword, page: page), checking: checking)
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
    
    func getBackdropImages(id: Int, type: HomeCategoryOption) -> Single<BackdropsMovie> {
        switch type {
        case .movie:
            return api.request(router: .getAllBackdropsMovie(id: id), checking: .unchecked)
        case .show:
            return api.request(router: .getAllBackdropsShow(id: id), checking: .unchecked)
        }
    }
    
    func getMoviesByGenre(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .getMoviesByGenre(id: id, page: page), checking: checking)
    }
    
    func getMoviesByProvider(id: Int, sortBy: String, page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .getMoviesByProvider(id: id, sortBy: sortBy, page: page), checking: checking)
    }
    
    func getShowsByGenre(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>> {
        return api.request(router: .getShowsByGenre(id: id, page: page), checking: checking)
    }
    
    func getReview(id: Int, page: Int, checking: CheckingType, type: HomeCategoryOption) -> Single<BasePageResponse<[Comment]>> {
        switch type {
        case .movie:
            return api.request(router: .getMovieReview(id: id, page: page), checking: checking)
        case .show:
            return api.request(router: .getShowReview(id: id, page: page), checking: checking)
        }
    }
    
    func getVideo(id: Int, type: HomeCategoryOption) -> Single<BaseResponse<[MovieVideo]>> {
        switch type {
        case .movie:
            return api.request(router: .getMovieVideo(id: id), checking: .checked)
        case .show:
            return api.request(router: .getShowVideo(id: id), checking: .checked)
        }
       
    }
    
    func getShowDetail(id: Int) -> Single<ShowDetail> {
        return api.request(router: .getShowDetail(id: id), checking: .checked)
    }
    
    func getShowCredit(id: Int) -> Single<MovieCredit> {
        return api.request(router: .getShowCredit(id: id), checking: .unchecked)
    }
    
    func getSimilarShow(id: Int, page: Int, checking: CheckingType) -> Single<BasePageResponse<[TvShowCommonInfomation]>> {
        return api.request(router: .getSimilarShow(id: id, page: page), checking: checking)
    }
    
    func getTvShowStreamOn(id: Int) -> Single<MovieStreamOn> {
        return api.request(router: .getTvShowStreamOn(id: id), checking: .unchecked)
    }
    
    func getMovieStreamOn(id: Int) -> Single<MovieStreamOn> {
        return api.request(router: .getMovieStreamOn(id: id), checking: .unchecked)
    }
    
    func getListFreeMovieToWatch(page: Int, checking: CheckingType) -> Single<BasePageResponse<[MovieCommonInfomation]>> {
        return api.request(router: .getListFreeMovieToWatch(page: page), checking: checking)
    }
}

