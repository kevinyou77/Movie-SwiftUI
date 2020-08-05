//
//  HomeGameListViewModel.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Combine
import Foundation

class HomeGameListViewModel: ObservableObject {
	
	@Published var games: [GameListDescription] = []
	var cancellable: AnyCancellable?
	
	private let storageModel: FavoriteGameStorageModel
	
	init(storageModel: FavoriteGameStorageModel = FavoriteGameStorageModel.shared) {
		
		self.storageModel = storageModel
		
		getGames()
	}
}

extension HomeGameListViewModel {
	
	func getGames() {
		
		let queryParams: [String: String] = [
			"page_size": "10"
		]
		
		let request: AnyPublisher<GameListResponse, Error> = RawgAPI.request(
            .games,
            queryParams: queryParams
        )
		cancellable = request.mapError { (error) -> Error in
			print(error)
			return error
		}
		.sink(
			receiveCompletion: { _ in },
			receiveValue: {
                
                self.games = self.assignFavoritedGames(gameList: $0.gameLists)
			}
		)
	}
    
    func notifyDidFavoriteGame() {
        
        NotificationCenter.default.post(name: .didFavoriteGame, object: nil)
    }
}

extension HomeGameListViewModel {
    
    func assignFavoritedGames(gameList: [GameListDescription]) -> [GameListDescription] {
        
        let favoriteGameIds = getFavoriteGameIdsFromCache()
        return gameList.map { game -> GameListDescription in
            
            guard
                favoriteGameIds.contains(game.id) else {
                    return game
            }
            
            var gameCopy = game
            gameCopy.favorited = true
            return gameCopy
        }
    }
    
    func onSaveToDatabase(index: Int, with game: GameListDescription) -> (() -> Void) {
        
        return {

            if game.favorited {
                self.removeFromDatabase(index: index, by: game.id)
            } else {
                self.insertToDatabase(index: index, with: game)
            }

            self.notifyDidFavoriteGame()
        }
    }
    
    func insertToDatabase(index: Int, with game: GameListDescription) {
        
        let insertSuccess = self.insertFavoriteToDatabase(with: game)
        
        if insertSuccess {
            self.games[index].favorited = true
        }
    }
    
    func removeFromDatabase(index: Int, by id: Int) {
            
        let deleteSuccess = self.removeFavoriteFromDatabase(by: id)
        
        if deleteSuccess {
            self.games[index].favorited = false
        }
    }
}

extension HomeGameListViewModel {
    
    func removeFavoriteFromDatabase(by id: Int) -> Bool {
        storageModel.deleteFavoriteGame(by: id)
    }
    
    func getFavoriteGameIdsFromCache() -> [Int] {
        storageModel.getFavoriteGameIds()
    }
    
    func insertFavoriteToDatabase(with gameData: GameListDescription) -> Bool {
        storageModel.insertFavoriteGame(item: gameData)
    }
}
