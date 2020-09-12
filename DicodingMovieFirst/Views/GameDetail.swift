//
//  Gamedetail.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import SwiftUI

struct GameDetailView: View {
	
	let gameId: Int
	let gameTitle: String
	let cover: String
	
	let gameListDescription: GameListDescription
	
	@ObservedObject var viewModel: GameDetailViewModel
	
	@Environment(\.imageCache) private var cache: ImageCache
	
	init(
		gameId: Int,
		gameTitle: String,
		cover: String,
		gameListDescription: GameListDescription
	) {

		self.gameId = gameId
		self.gameTitle = gameTitle
		self.gameListDescription = gameListDescription
		self.cover = cover
		self.viewModel = GameDetailViewModel(
			id: gameId,
			favorited: gameListDescription.favorited
		)
	}
	
	var body: some View {
		MainStack()
			.navigationBarTitle(Text(gameTitle), displayMode: .inline)
			.navigationBarHidden(false)
 	}
	
	private func MainStack() -> some View {
		
		ScrollView(.vertical) {
			
			GameInformation()
			GameDescription()
		}
		.onAppear(perform: {
			self.viewModel.getGameDetail(by: self.gameId)
		})
		.onDisappear(perform: {
			self.viewModel.notifyDidUnfavoriteGame()
		})
	}
}

extension GameDetailView {
	
	private func GameDescription() -> some View {
		
		let description = viewModel.gameDetail.gameDetailDescription ?? ""
		let inset = EdgeInsets(top: -20, leading: 20, bottom: 10, trailing: 20)
		return Text(description).padding(inset)
	}
	
	private func GameInformation() -> some View {
		
		let platformInfo = viewModel.getPlatformInfo(from: viewModel.gameDetail.platforms)
		
        let releaseDateString = viewModel.gameDetail.released
        let localeString = DateHelper.convertStringToDateString(from: releaseDateString ?? "") ?? "TBA"
		let url = URL(string: cover)
        
		return Group {
			
			if viewModel.gameDetail.name == nil {
				
				CommonUI
					.EmptyState(text: "Loading...")
					.padding(20)
			} else {
				
				Group {
					
					GameImage(url: url)
					GameInformation(releaseDate: localeString, platformInfo: platformInfo)
				}
			}
		}
	}
	
	private func GameInformation(releaseDate: String, platformInfo: String) -> some View {
		
		VStack(alignment: .leading) {
			
			Text(viewModel.gameDetail.name ?? "")
				.font(.largeTitle)
				.fontWeight(.bold)
			
			VStack(alignment: .leading) {
				Text("\(platformInfo)")
					.fontWeight(.bold)
				Text("Released \(releaseDate)")
					.font(.subheadline)
				Text("Metacritic: \(viewModel.gameDetail.metacritic ?? 0)/100")
					.font(.subheadline)
				
				Button(
					action: viewModel.onSaveToDatabase(with: gameListDescription),
					label: {
						
						HStack {
							
							Image(systemName: "star.fill")
								.foregroundColor(viewModel.favorited ? .yellow : .black)

							Text("Favorite")
								.fontWeight(.semibold)
								.font(.subheadline)
						}
					}
				)
				.buttonStyle(PlainButtonStyle())
			}
		}
		.padding(
			EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
		)
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	private func GameImage(url: URL?) -> some View {
		
		if let url = url {
			return AnyView(GameImageView(url: url))
		}
		
		return AnyView(EmptyView())
	}
	
	private func GameImageView(url: URL) -> some View {
		
		NetworkImageView(
			url: url,
			cache: self.cache,
			placeholder: Text("Loading")
						  .frame(maxWidth: .infinity, alignment: .center),
			configuration: { $0.resizable() }
		)
		.aspectRatio(1.7, contentMode: .fit)
	}
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
		GameDetailView(gameId: 3498, gameTitle: "a", cover: "", gameListDescription: GameListDescription())
    }
}
