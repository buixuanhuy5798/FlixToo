//  
//  ActorProfileEntity.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit

struct ActorCommonInfo: Codable {
    let id: Int?
    let name, originalName, mediaType: String?
    let adult: Bool?
    let popularity: Double?
    let gender: Int?
    let knownForDepartment, profilePath: String?
    let knownFor: [KnownFor]?

    var knowForDisplay: String {
        var result = ""
        if let knownFor = knownFor {
            for movie in knownFor {
                let movieName = movie.originalTitle
                let releaseYear = movie.releaseDate?.prefix(4)
                result += "\(movieName ?? "") (\(releaseYear ?? ""))\n"
            }
        }
        result.removeLast()
        return result
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case originalName = "original_name"
        case mediaType = "media_type"
        case adult, popularity, gender
        case knownForDepartment = "known_for_department"
        case profilePath = "profile_path"
        case knownFor = "known_for"
    }
}

// MARK: - KnownFor
struct KnownFor: Codable {
    let backdropPath: String?
    let id: Int?
    let title, originalTitle, overview, posterPath: String?
    let mediaType: String?
    let adult: Bool?
    let originalLanguage: String?
    let genreIDS: [Int]?
    let popularity: Double?
    let releaseDate: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id, title
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case originalLanguage = "original_language"
        case genreIDS = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

