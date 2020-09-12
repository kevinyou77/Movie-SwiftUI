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
    
    init() {
        
        UINavigationBar.appearance().backgroundColor = .white
    }
}

extension FavoriteGamesView {
	
	private func GameList(_ gameList: [GameListDescription]) -> some View {
		
        let gameListWithIndex = gameList.enumerated().map { $0 }

		return Group {

			if viewModel.games.isEmpty {
				CommonUI.EmptyState(
					text: "No favorite game yet, try add some games to your favorites!"
				)
			}
			
			List(gameListWithIndex, id: \.element.id) { (index, game) in
				self.GameDescription(index: index, game: game)
					.frame(height: 320)
			}
			.padding(.horizontal, -20)
			.listStyle(GroupedListStyle())
			.environment(\.defaultMinListRowHeight, 320)
		}
	}
	
    private func GameDescription(index: Int, game: GameListDescription) -> some View {

		Group {
            GameDescriptionView(index: index, game: game)
			NavigationLink(destination: GameDetailView(gameId: game.id, gameTitle: game.title, cover: game.cover, gameListDescription: game)) {
				
				EmptyView()
			}
			.frame(width: 0)
			.opacity(0)
		}
	}
	
    private func GameDescriptionView(index: Int, game: GameListDescription) -> some View {
		
		let roundedGameRating = game.rating?.roundValueToString(toPlaces: "%.2f") ?? "N/A"
        let localizedDate = DateHelper.convertStringToDateString(from: game.releaseDate  ?? "TBA")

        return VStack(alignment: .leading) {
            
            GameImageView(named: game.cover)
            
            HStack(spacing: 5) {
                VStack(alignment: .leading) {
                    Text(game.title)
                        .fontWeight(.bold)
                        .font(.system(size: 22))
                    
                    Text("\(roundedGameRating) from \(game.ratingsCount ?? 0) ratings")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    
                    Text("Released \(localizedDate ?? "TBA")")
                        .font(.caption)
                }
                
                Spacer()

                Button(
                    action: viewModel.onSaveToDatabase(index: index, with: game),
                    label: {

                        Image(systemName: "star.fill")
                            .foregroundColor(game.favorited ? .yellow : .black)

                        Text("Favorite")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                    }
                )
                .buttonStyle(PlainButtonStyle())
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        }
	}

	private func GameImageView(named imageName: String) -> some View {

		return NetworkImageView(
			url: URL(string: imageName)!,
			cache: self.cache,
			placeholder: Text("Loading"),
			configuration: { $0.resizable() }
		)
		.aspectRatio(1.7, contentMode: .fill)
		.edgesIgnoringSafeArea(.all)
	}
}
