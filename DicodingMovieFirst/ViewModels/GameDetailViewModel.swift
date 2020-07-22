//
//  GameDetailViewModel.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 19/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Combine

class GameDetailViewModel: ObservableObject {
	
	let id: Int
	
	@Published var gameDetail: GameDetail = GameDetail()
	var cancellable: AnyCancellable?
	
	init(id: Int) {
		
		self.id = id
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
