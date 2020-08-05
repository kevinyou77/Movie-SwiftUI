//
//  HomeGameListView.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import SwiftUI

struct FavoriteGamesView: View {
	
	@Environment(\.imageCache) private var cache: ImageCache
	
	@ObservedObject private var viewModel: FavoriteGamesListViewModel = FavoriteGamesListViewModel()
	
    var body: some View {
		
		VStack {
			GameList(viewModel.games)
		}
    }
}

extension FavoriteGamesView {
	
	private func GameList(_ gameList: [GameListDescription]) -> some View {
		
		Group {
			if viewModel.games.isEmpty {
				EmptyTextView()
			}
			
			List(gameList) {
				self.GameDescription(game: $0)
			}
			.padding(.horizontal, -20)
		}
	}

	private func EmptyTextView() -> some View {

		HStack(alignment: .center) {
			VStack(alignment: .center) {
				
				Text("No favorite game yet, try add some games to your favorites!")
					.frame(maxWidth: .infinity, alignment: .center)
			}
		}
	}
	
	private func GameDescription(game: GameListDescription) -> some View {

		Group {
			GameDescriptionView(game: game)
			NavigationLink(destination: GameDetailView(gameId: game.id, gameTitle: game.title)) {
				
				EmptyView()
			}
			.frame(width: 0)
			.opacity(0)
		}
	}
	
	private func GameDescriptionView(game: GameListDescription) -> some View {
		
		let roundedGameRating = game.rating.roundValueToString(toPlaces: "%.2f")
		return VStack(alignment: .leading) {

			GameImageView(named: game.cover)

			VStack(alignment: .leading) {

				Text(game.title)
					.fontWeight(.bold)
					.font(.system(size: 22))

				Text("\(roundedGameRating) from \(game.ratingsCount) ratings")
					.fontWeight(.semibold)
					.font(.subheadline)

                Text("Released \(DateHelper.convertStringToDateString(from: game.releaseDate ?? "") ?? "TBA")")
					.font(.caption)
			}
			.padding(20)
		}
	}

	private func GameImageView(named imageName: String) -> some View {
		
		NetworkImageView(
			url: URL(string: imageName)!,
			cache: self.cache,
			placeholder: Text("Loading"),
			configuration: { $0.resizable() }
		)
		.aspectRatio(1.7, contentMode: .fit)
	}
}
