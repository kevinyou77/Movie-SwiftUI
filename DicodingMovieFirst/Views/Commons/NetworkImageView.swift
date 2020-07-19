//
//  NetworkImage.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 18/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import SwiftUI

struct NetworkImageView<Placeholder: View>: View {

    @ObservedObject private var loader: NetworkImage
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image
    
    init(
		url: URL,
		cache: ImageCache? = nil,
		placeholder: Placeholder? = nil,
		configuration: @escaping (Image) -> Image = { $0 }
	) {
        loader = NetworkImage(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }
    
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
        Group {
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
            } else {
                placeholder
            }
        }
    }
}
