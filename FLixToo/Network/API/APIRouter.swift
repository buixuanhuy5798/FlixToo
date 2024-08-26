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
    case getPopularPeople
    
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
        case .getPopularPeople:
            return "/trending/person/week"
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
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var header: [String: String] {
        var header = ["accept": "application/json",
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
