//
//  HomeGameListViewModel.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Combine
import Foundation

class FavoriteGamesListViewModel: ObservableObject {
	
	@Published var games: [GameListDescription] = []
	var cancellable: AnyCancellable?
	
	let favoriteGameStorageModel: FavoriteGameStorageModel
	
	init(favoriteGameStorageModel: FavoriteGameStorageModel = FavoriteGameStorageModel.shared) {
		
		self.favoriteGameStorageModel = favoriteGameStorageModel
		
		configureViewModel()
	}
}

extension FavoriteGamesListViewModel {
    
    func configureViewModel() {
        
        getGamesFromCache()
        addDidFavoriteGameObserver()
    }
	
	@objc func getGamesFromCache() {
		
		self.games = favoriteGameStorageModel.getFavoriteGames()
	}
    
    func addDidFavoriteGameObserver() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getGamesFromCache),
            name: .didFavoriteGame,
            object: nil
        )
    }
}
