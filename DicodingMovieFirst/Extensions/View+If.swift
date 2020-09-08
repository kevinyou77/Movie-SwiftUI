//
//  View+If.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 05/09/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import SwiftUI

extension View {
	
   @ViewBuilder
   func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }
}
