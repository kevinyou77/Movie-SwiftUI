//
//  About.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 22/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import SwiftUI

struct AboutView: View {
	
	var body: some View {
		
		VStack(alignment: .center) {
			
			Image("kevin")
				.resizable()
				.frame(width: 220, height: 300, alignment: .center)
			
			Text("Kevin Yulias")
            Text("Laki-laki")
            Text("8 Feb 1998")
		}
	}
}
