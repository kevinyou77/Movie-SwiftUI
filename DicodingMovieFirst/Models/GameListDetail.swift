//
//  GameListDetail.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Foundation

struct GameDetailResponse: Codable {
	
	let gameDetail: GameDetail
	
	enum CodingKeys: String, CodingKey {
		
		case gameDetail = "results"
	}
}

// MARK: - GameDetail
struct GameDetail: Codable {
    var id: Int?
    var slug, name, nameOriginal, gameDetailDescription: String?
    var metacritic: Int?
    var released: String?
    var backgroundImage: String?
    var website: String?
    var rating: Double?
    var platforms: [Platform]?

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case nameOriginal = "name_original"
        case gameDetailDescription = "description"
        case metacritic
        case released
        case backgroundImage = "background_image"
        case website, rating
        case platforms
    }
}

struct PlatformInfo: Codable {
    var id: Int?
    var slug, name: String?
}

struct MetacriticPlatform: Codable {
    var metascore: Int?
    var url: String?
}

struct Platform: Codable {
    var platform: PlatformInfo?
    var releasedAt: String?
    var requirements: Requirements?

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

struct Requirements: Codable {
    var minimum, recommended: String?
}
