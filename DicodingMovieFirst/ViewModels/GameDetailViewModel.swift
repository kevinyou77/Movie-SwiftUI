//
//  GameDetailViewModel.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 19/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Combine
import Foundation

class GameDetailViewModel: ObservableObject {
	
	let id: Int
	
	@Published var gameDetail: GameDetail = GameDetail()
	@Published var favorited: Bool = false
	
	var cancellable: AnyCancellable?
	
	let favoriteGameStorageModel: FavoriteGameStorageModel
	
	init(
		id: Int,
		favorited: Bool,
		favoriteGameStorageModel: FavoriteGameStorageModel = FavoriteGameStorageModel.shared
	) {

		self.id = id
		self.favorited = favorited
		self.favoriteGameStorageModel = favoriteGameStorageModel
	}
}

extension GameDetailViewModel {
	
	func getGameDetail(by id: Int) {
		
		let request: AnyPublisher<GameDetail, Error> = RawgAPI.request(
			.gameDetail(id: id),
			queryParams: [:]
		)

		cancellable = request.mapError { (error) -> Error in
			
			print(error)
			return error
		}
		.sink(
			receiveCompletion: { _ in },
			receiveValue: { res in
				
				self.gameDetail = res
			}
		)
	}
	
	func getPlatformInfo(from platforms: [Platform]?) -> String {
		
		guard let platforms = platforms else {
			return "No platform announced yet."
		}
		
		return platforms.reduce("", { prev, curr in
			prev == "" ? "\(curr.platform?.name ?? "")" : "\(prev), \(curr.platform?.name ?? "")"
		})
	}
}

extension GameDetailViewModel {
    
    func onSaveToDatabase(with game: GameListDescription) -> (() -> Void) {
           
		return {

			let favoriteGameIds: [Int] = self.getFavoriteGameIdsFromCache()
				
			if favoriteGameIds.contains(game.id) {

				_ = self.removeFavoriteFromDatabase(by: game.id)
				self.favorited = false
			} else {
				
				_ = self.insertFavoriteToDatabase(with: game)
				self.favorited = true
			}
			
			self.notifyDidFavoriteGame()
		}
   }
}

extension GameDetailViewModel {
    
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

extension GameDetailViewModel {
	
	func notifyDidFavoriteGame() {
        
        NotificationCenter.default.post(name: .didFavoriteGame, object: nil)
    }
	
	func notifyDidUnfavoriteGame() {
		
		NotificationCenter.default.post(name: .didUnfavoriteGame, object: nil)
	}
}
