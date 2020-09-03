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
}
