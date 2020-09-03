//
//  SwiftUI+EmptyState.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 25/08/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import SwiftUI

class CommonUI {
	
	static func EmptyState(text: String) -> some View {
		HStack(alignment: .center) {
			VStack(alignment: .center) {
				
				Text(text)
					.frame(maxWidth: .infinity, alignment: .center)
			}
		}
	}
}
