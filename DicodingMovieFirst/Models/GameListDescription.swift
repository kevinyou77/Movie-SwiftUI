//
//  GameListDescription.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Foundation

struct GameListResponse: Codable {
	
	let gameLists: [GameListDescription]
	
	enum CodingKeys: String, CodingKey {
		
		case gameLists = "results"
	}
}

struct GameListDescription: Codable, Identifiable {

	var id: Int = Int()
	var gameId: String = ""
	var cover: String = ""
	var rank: String? = ""
	var title: String = ""
	var releaseDate: String? = ""
	var rating: Double? = 0
	var ratingsCount: Int? = 0
	var favorited: Bool = false
	
	enum CodingKeys: String, CodingKey {
		
		case cover = "background_image"
		case releaseDate = "released"
		case title = "name"
		case rating
		case id
		case ratingsCount = "ratings_count"
	}
    
    init() {}
    
    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
		self.cover = try (container.decodeIfPresent(String.self, forKey: .cover) ?? "")
        self.title = try container.decode(String.self, forKey: .title)
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        self.ratingsCount = try container.decodeIfPresent(Int.self, forKey: .ratingsCount)
    }
}
