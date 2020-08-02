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
	var cover: String = "photo"
	var rank: String = "#1"
	var title: String = "Cyberpunk 2077"
	var releaseDate: String = "11 November 2020"
	var rating: Double = 0
	var ratingsCount: Int = 0
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
