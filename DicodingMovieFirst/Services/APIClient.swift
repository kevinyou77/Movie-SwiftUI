//
//  APIClient.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Foundation
import Combine

struct APIClient {
	
	struct Response<T> {
		let value: T
		let response: URLResponse
	}
	
	func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
		
		URLSession.shared
			.dataTaskPublisher(for: request)
			.tryMap { res -> Response<T> in
				
				let value = try JSONDecoder().decode(T.self, from: res.data)
				return Response(value: value, response: res.response)
			}
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
}
