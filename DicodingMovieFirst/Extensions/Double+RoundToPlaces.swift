//
//  Double+RoundToPlaces.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 21/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Foundation

extension Double {
	
	func roundValueToString(toPlaces format: String) -> String {
		
		let roundedValue = (1000.0 * self).rounded() / 1000.0
		let roundedValueString = String(format: format, roundedValue)
		
		return roundedValueString
	}
}
