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
    
    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(gameDetailDescription, forKey: .gameDetailDescription)
    }
    
    init() {}
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let gameDescription = try container.decode(String.self, forKey: .gameDetailDescription)
        self.gameDetailDescription = StringHelper.eraseAllHTMLTags(from: gameDescription)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.slug = try container.decode(String.self, forKey: .slug)
        self.name = try container.decode(String.self, forKey: .name)
        self.released = try container.decode(String.self, forKey: .released)
        self.platforms = try container.decode([Platform].self, forKey: .platforms)
        self.metacritic = try container.decode(Int.self, forKey: .metacritic)
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
