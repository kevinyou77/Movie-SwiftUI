//
//  HomeGameListViewModel.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Combine

class HomeGameListViewModel: ObservableObject {
	
	@Published var games: [GameListDescription] = []
	var cancellable: AnyCancellable?
	
	init() {
		getMovies()
	}
}

extension HomeGameListViewModel {
	
	func getMovies() {
		
		let queryParams: [String: String] = [
			"page_size": "10"
		]
		
		let request: AnyPublisher<GameListResponse, Error> = RawgAPI.request(.games, queryParams: queryParams)
		cancellable = request.mapError { (error) -> Error in
			print(error)
			return error
		}
		.sink(
			receiveCompletion: { _ in },
			receiveValue: {
				self.games = $0.gameLists
			}
		)
	}
}
