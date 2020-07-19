//
//  NetworkImage.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 18/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Combine
import SwiftUI

class NetworkImage: ObservableObject {
	
	@Published var image: UIImage?
	
	private(set) var isLoading = false
	
	private let url: URL
	private var cache: ImageCache?
	private var cancellable: AnyCancellable?
	
	private static let imageProcessingQueue: DispatchQueue = DispatchQueue(label: "image-download")
	
	init(url: URL, cache: ImageCache? = nil) {
		
		self.url = url
		self.cache = cache
	}
	
	deinit {
		cancel()
	}
	
	func load() {
		
		guard !isLoading else {
			return
		}
		
		if let image = cache?[url] {
			
			self.image = image
			return
		}
		
		cancellable = URLSession.shared
			.dataTaskPublisher(for: url)
			.map { UIImage(data: $0.data) }
			.replaceError(with: nil)
			.handleEvents(
				receiveSubscription: { [weak self] _ in self?.onStart() },
				receiveOutput: { [weak self] in self?.cache($0) },
				receiveCompletion: { [weak self] _ in self?.onFinish() },
				receiveCancel: { [weak self] in self?.onFinish() }
			)
			.subscribe(on: Self.imageProcessingQueue)
			.receive(on: DispatchQueue.main)
			.assign(to: \.image, on: self)
	}
	
	func cancel() {
		cancellable?.cancel()
	}
	
	func onStart() {
		isLoading = true
	}
	
	func onFinish() {
		isLoading = false
	}
	
	private func cache(_ image: UIImage?) {
		image.map { cache?[url] = $0 }
	}
}
