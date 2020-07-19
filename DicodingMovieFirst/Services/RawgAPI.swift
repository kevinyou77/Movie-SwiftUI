//
//  RawgAPI.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Foundation
import Combine

enum RawgAPI {
	static let apiClient = APIClient()
	static let baseUrl = URL(string: "https://api.rawg.io/api")!
}

enum RawgAPIPath {
	
	case games
	case gameDetail(id: Int)
	
	var value: String {
		
		switch self {
		case .games:
			return "/games"
		case .gameDetail(let id):
			return "/games/\(id)"
		}
	}
}

extension RawgAPI {
	
	static func request<T: Codable>(
		_ path: RawgAPIPath,
		queryParams: [String: String]
	) -> AnyPublisher<T, Error> {
		
		guard
			var components = URLComponents(
				url: baseUrl.appendingPathComponent(path.value),
				resolvingAgainstBaseURL: true
			) else {
			
			fatalError("Could not create url components")
		}
		
		components.setQueryItems(with: queryParams)
		let request = URLRequest(url: components.url!)
		return apiClient.run(request)
			.map(\.value)
			.eraseToAnyPublisher()
	}
}
