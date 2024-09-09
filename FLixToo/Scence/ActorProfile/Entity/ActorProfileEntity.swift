//  
//  ActorProfileEntity.swift
//  FLixToo
//
//  Created by buixuanhuy on 26/08/2024.
//

import UIKit

struct MobieByActor: Codable {
    let cast, crew: [MovieCast]?
    let id: Int?
}

// MARK: - Cast
struct MovieCast: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let character, creditID: String?
    let order: Int?
    let mediaType: String?
    let originalName, firstAirDate, name: String?
    let episodeCount: Int?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case character
        case creditID = "credit_id"
        case order
        case mediaType = "media_type"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case name
        case episodeCount = "episode_count"
        case job
    }
}

struct ActorDetailInfo: Codable {
    let adult: Bool?
    let alsoKnownAs: [String]?
    let biography, birthday: String?
    let deathday: String?
    let gender: Int?
    let homepage: String?
    let id: Int?
    let imdbID, knownForDepartment, name, placeOfBirth: String?
    let popularity: Double?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}

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
        if !result.isEmpty {
            result.removeLast()
        }
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
