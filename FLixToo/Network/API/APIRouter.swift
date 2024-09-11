//
//  APIRouter.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import Alamofire

enum APIRouter {
    case getListPopularMovie(page: Int)
    case getListUpcomingMovies(page: Int)
    case getListNowPlayingMovies(page: Int)
    case getListMovieProviders
    case getMovieDetail(id: String)
    case searchMovieName(keyword: String, page: Int)
    case getListTVPopular(page: Int)
    case getPopularPeople
    case getDetailPeople(id: Int)
    
    case getListPopularTVShow(page: Int)
    case getListUpcomingTVShow(page: Int)
    case getListTopRatedTVShow(page: Int)
    case getListFreeMovieToWatch(page: Int)
    case getMovieCredit(id: Int)
    case getSimilarMovie(id: Int, page: Int)
    case getAllBackdropsMovie(id: Int)
    case getAllBackdropsShow(id: Int)
    case getMovieReview(id: Int, page: Int)
    case getShowReview(id: Int, page: Int)
    case getMoviesByGenre(id: Int, page: Int)
    case getShowsByGenre(id: Int, page: Int)
    case getMovieVideo(id: Int)
    
    case getShowDetail(id: Int)
    case getShowCredit(id: Int)
    case getSimilarShow(id: Int, page: Int)
    case getShowVideo(id: Int)
    
    case getMoviesByProvider(id: Int, sortBy: String, page: Int)
    case getAllMovieOfActor(id: Int)
    case getTvShowStreamOn(id: Int)
    case getMovieStreamOn(id: Int)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var url: String {
        switch self {
        default:
            // Base URL
            return "https://api.themoviedb.org/3"
        }
    }
    
    var path: String {
        switch self {
        case .getListPopularMovie:
            return "/movie/popular"
        case .getListMovieProviders:
            return "/watch/providers/movie"
        case .getListUpcomingMovies:
            return "/movie/upcoming"
        case .getListNowPlayingMovies:
            return "/movie/now_playing"
        case .getMovieDetail(let id):
            return "/movie/\(id)"
        case .searchMovieName:
            return "/search/keyword"
        case .getListTVPopular:
            return "/tv/popular"
        case .getPopularPeople:
            return "/trending/person/week"
        case .getDetailPeople(let id):
            return "person/\(id)"
        case .getListPopularTVShow:
            return "/tv/popular"
        case .getListUpcomingTVShow:
            return "/tv/on_the_air"
        case .getListTopRatedTVShow:
            return "/tv/top_rated"
        case .getMovieCredit(let id):
            return "/movie/\(id)/credits"
        case .getSimilarMovie(let id, _):
            return "/movie/\(id)/similar"
        case .getAllBackdropsMovie(let id):
            return "/movie/\(id)/images"
        case .getAllBackdropsShow(let id):
            return "/tv/\(id)/images"
        case .getMoviesByGenre:
            return "/discover/movie"
        case .getShowsByGenre:
            return "/discover/tv"
        case .getMovieReview(let id, _):
            return "/movie/\(id)/reviews"
        case .getShowReview(let id, _):
            return "/tv/\(id)/reviews"
        case .getMovieVideo(let id):
            return "/movie/\(id)/videos"
        case .getShowDetail(let id):
            return "tv/\(id)"
        case .getShowCredit(let id):
            return "/tv/\(id)/credits"
        case .getSimilarShow(let id, _):
            return "/tv/\(id)/similar"
        case .getShowVideo(let id):
            return "/tv/\(id)/videos"
        case .getMoviesByProvider:
            return "/discover/movie"
        case .getAllMovieOfActor(let id):
            return "/person/\(id)/combined_credits"
        case .getTvShowStreamOn(let id):
            return "/tv/\(id)/watch/providers"
        case .getMovieStreamOn(let id):
            return "/movie/\(id)/watch/providers"
        case .getListFreeMovieToWatch:
            return "discover/movie"
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .getListPopularMovie(let page):
            return ["page": page]
        case .getListUpcomingMovies(let page):
            return ["page": page]
        case .getListNowPlayingMovies(let page):
            return ["page": page]
        case .searchMovieName(let keyword, let page):
            return ["page": page, "query": keyword]
        case .getListTVPopular(let page):
            return ["page": page]
        case .getListPopularTVShow(let page):
            return ["page": page]
        case .getListUpcomingTVShow(let page):
            return ["page": page]
        case .getListTopRatedTVShow(let page):
            return ["page": page]
        case .getSimilarMovie(_, let page):
            return ["page": page]
        case .getMoviesByGenre(let id, let page):
            return [
                "with_genres": id,
                "page": page,
                "include_adult": false,
                "include_video": false,
                "language": "en-US",
                "sort_by": "popularity.desc"
            ]
        case .getShowsByGenre(let id, let page):
            return [
                "with_genres": id,
                "page": page,
                "include_adult": false,
                "include_video": false,
                "language": "en-US",
                "sort_by": "popularity.desc"
            ]
        case .getMovieReview(_, let page):
            return ["page": page]
        case .getShowReview(_, let page):
            return ["page": page]
        case .getMoviesByProvider(let id, let sortBy, let page):
            return [
                "with_watch_providers": id,
                "watch_region": "GB",
                "page": page,
                "include_adult": false,
                "include_video": false,
                "language": "en-US",
                "sort_by": sortBy
            ]
        case .getShowDetail:
            return ["value": 8]
        case .getListFreeMovieToWatch(let page):
            return ["page": page,
                    "with_watch_monetization_types": "free"]
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var header: [String: String] {
        let header = ["accept": "application/json",
                      "Authorization": KeychainStorage.shared.apiKey ?? ""]
        return header
    }
}

extension APIRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = path.isEmpty ? try url.asURL() : try url.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.timeoutInterval = 60
        urlRequest.headers = HTTPHeaders(header)
        urlRequest = try encoding.encode(urlRequest, with: params)
        return urlRequest
    }
}
