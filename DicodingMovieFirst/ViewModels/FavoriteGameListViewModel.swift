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
        configureNotificationCenter()
    }
	
	@objc func getGamesFromCache() {
		
		self.games = favoriteGameStorageModel.getFavoriteGames()
	}
}

extension FavoriteGamesListViewModel {
    
    func configureNotificationCenter() {
        
        addDidFavoriteGameObserver()
    }
    
    func addDidFavoriteGameObserver() {
           
       NotificationCenter.default.addObserver(
           self,
           selector: #selector(getGamesFromCache),
           name: .didFavoriteGame,
           object: nil
       )
    }
       
    func notifyDidUnfavoriteGame() {
       
       NotificationCenter.default.post(name: .didUnfavoriteGame, object: nil)
    }
}

extension FavoriteGamesListViewModel {
    
    func onSaveToDatabase(index: Int, with game: GameListDescription) -> (() -> Void) {
           
       return {

            self.removeFromDatabase(index: index, by: game.id)
            self.notifyDidUnfavoriteGame()
       }
   }
       
   func removeFromDatabase(index: Int, by id: Int) {
           
        let deleteSuccess = self.removeFavoriteFromDatabase(by: id)
       
        if deleteSuccess {
            self.games.remove(at: index)
        }
   }
}

extension FavoriteGamesListViewModel {
    
    func removeFavoriteFromDatabase(by id: Int) -> Bool {
        favoriteGameStorageModel.deleteFavoriteGame(by: id)
    }
    
    func getFavoriteGameIdsFromCache() -> [Int] {
        favoriteGameStorageModel.getFavoriteGameIds()
    }
    
    func insertFavoriteToDatabase(with gameData: GameListDescription) -> Bool {
        favoriteGameStorageModel.insertFavoriteGame(item: gameData)
    }
}
