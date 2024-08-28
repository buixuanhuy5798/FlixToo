//  
//  SearchEntity.swift
//  FLixToo
//
//  Created by Huy Bùi Xuân on 23/8/24.
//

import UIKit

class SearchEntity {
}

struct SearchMovieNameResponse: Codable {
    let page: Int
    let results: [MovieName]
    let total_pages: Int
    let total_results: Int
}

struct MovieName: Codable {
    let id: Int
    let name: String
}

struct TvShowCommonInfomation: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalName, overview: String?
    let popularity: Double?
    let posterPath: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
