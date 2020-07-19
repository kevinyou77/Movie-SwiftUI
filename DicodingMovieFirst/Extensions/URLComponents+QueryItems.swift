//
//  URLComponents+QueryItems.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 18/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Foundation

extension URLComponents {
	
	mutating func setQueryItems(with parameters: [String: String]) {
		self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
	}
}
