//
//  HomeGameListViewModel.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Combine

class FavoriteGamesListViewModel: ObservableObject {
	
	@Published var games: [GameListDescription] = []
	var cancellable: AnyCancellable?
	
	let favoriteGameStorageModel: FavoriteGameStorageModel
	
	init(favoriteGameStorageModel: FavoriteGameStorageModel = FavoriteGameStorageModel.shared) {
		
		self.favoriteGameStorageModel = favoriteGameStorageModel
		
		getGamesFromCache()
	}
}

extension FavoriteGamesListViewModel {
	
	func getGamesFromCache() {
		
		self.games = favoriteGameStorageModel.getFavoriteGames()
	}
}
