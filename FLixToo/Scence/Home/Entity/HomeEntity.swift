//  
//  HomeEntity.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

enum HomeCategoryOption {
    case movie
    case show
    
    func getTitle() -> String {
        switch self {
        case .movie:
            return "Explore\nMovies"
        case .show:
            return "Explore\nShows"
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .movie:
            return UIImage(named: "movie_categories_image")
        case .show:
            return UIImage(named: "show_categories_image")
        }
    }
}

enum HomeCollectionSectionData {
    case categories([HomeCategoryOption])
    case tredingMovies([MovieCommonInfomation])
    case nowPlaying([MovieCommonInfomation])
    case upcoming([MovieCommonInfomation])
    case movieProviders([MovieProvider])
    case popularPeople([ActorCommonInfo])
    case trendingShow([TvShowCommonInfomation])
    case upcomingShow([TvShowCommonInfomation])
    case topRatedShow([TvShowCommonInfomation])
    
    func getTitle() -> String {
        switch self {
        case .categories:
            return "Categories"
        case .tredingMovies:
            return "Trending Movies"
        case .nowPlaying:
            return "Recently Released Movies"
        case .upcoming:
            return "Upcoming Movies"
        case .popularPeople:
            return "Popular People"
        case .trendingShow:
            return "Trending Shows"
        case .upcomingShow:
            return "Upcoming Shows"
        case .topRatedShow:
            return "Top Rated Shows"
        default:
            return ""
        }
    }
    
    func getCount() -> Int {
        switch self {
        case .categories(let data):
            return data.count
        case .tredingMovies(let data):
            return data.count
        case .nowPlaying(let data):
            return data.count
        case .upcoming(let data):
            return data.count
        case .movieProviders(let data):
            return data.count
        case .popularPeople(let people):
            return people.count
        case .trendingShow(let shows):
            return shows.count
        case .upcomingShow(let shows):
            return shows.count
        case .topRatedShow(let shows):
            return shows.count
        }
    }
}


struct MovieCommonInfomation: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct MovieProvider: Codable {
    let displayPriority: Int?
    let logoPath, providerName: String?
    let providerID: Int?

    enum CodingKeys: String, CodingKey {
        case displayPriority = "display_priority"
        case logoPath = "logo_path"
        case providerName = "provider_name"
        case providerID = "provider_id"
    }
}
