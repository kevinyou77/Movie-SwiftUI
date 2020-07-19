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

// MARK: - AddedByStatus
struct AddedByStatus: Codable {
}

// MARK: - EsrbRating
struct EsrbRating: Codable {
    var id: Int?
    var slug, name: String?
}

// MARK: - MetacriticPlatform
struct MetacriticPlatform: Codable {
    var metascore: Int?
    var url: String?
}

// MARK: - Platform
struct Platform: Codable {
    var platform: EsrbRating?
    var releasedAt: String?
    var requirements: Requirements?

    enum CodingKeys: String, CodingKey {
        case platform
        case releasedAt = "released_at"
        case requirements
    }
}

// MARK: - Requirements
struct Requirements: Codable {
    var minimum, recommended: String?
}



//struct Platform: Codable {
//
//	var id: Int = 0
//	var slug: String = ""
//	var name: String = ""
//
//	enum CodingKeys: String, CodingKey {
//
//		case name
//		case slug
//		case id
//	}
//}
//
//struct Platforms: Codable {
//
//	var platform: [String: Platform] = [String: Platform]()
//
//	enum CodingKeys: String, CodingKey {
//		case platform
//	}
//}
//
//struct GameDetail: Codable, Identifiable {
//
//	var id: Int = Int()
//	var cover: String = ""
//	var description: String = ""
//	var rank: String = ""
//	var name: String = ""
//	var released: String = ""
//	var genre: String = ""
//	var publisher: String = ""
//	var ageRating: String = ""
//	var website: String = ""
//	var screenshots: [String]?
//	var rating: Int = Int()
//	var metacritic: Int = Int()
//	var platforms: Platforms = Platforms()
//	var platform: [String: Platform] = [String: Platform]()
//
//	enum CodingKeys: String, CodingKey {
//		case description
//		case name
//		case website
//		case released
//		case metacritic
//		case platforms
//		case platform
//	}
//
//	init() {}
//
//	init(from decoder: Decoder) throws {
//
//		let container = try decoder.container(keyedBy: CodingKeys.self)
//		let platformContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .platforms)
//		self.platform = try platformContainer.decode([String: Platform].self, forKey: .platform)
//	}
//}
