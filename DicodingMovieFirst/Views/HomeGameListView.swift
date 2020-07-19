//
//  HomeGameListView.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import SwiftUI

struct HomeGameListView: View {
	
	@State private var searchText = ""
	@State private var showCancelButton: Bool = false
	
	@Environment(\.imageCache) private var cache: ImageCache
	
	@ObservedObject private var viewModel: HomeGameListViewModel = HomeGameListViewModel()
	
    var body: some View {
		
		VStack {
		
			SearchBar()
			GameList(viewModel.games)
		}
    }
	
	private func GameList(_ gameList: [GameListDescription]) -> some View {
		
		List(gameList) { game in
			self.GameDescription(game: game)
		}
		.padding(.horizontal, -20)
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
		
		VStack(alignment: .leading) {
			
			NetworkImageView(
				url: URL(string: game.cover)!,
				placeholder: Text("Loading"),
				configuration: { $0.resizable() }
			)
			.aspectRatio(contentMode: .fit)
			
			VStack(alignment: .leading) {
				
				Text(game.rank)
				Text(game.title)
				Text(game.releaseDate)
			}
		}
	}
	
	private func SearchBar() -> some View {
		
		HStack {
			HStack {
				Image(systemName: "magnifyingglass")

				TextField("search", text: $searchText, onEditingChanged: { isEditing in
					self.showCancelButton = true
				}, onCommit: {
					print("onCommit")
				}).foregroundColor(.primary)

				Button(action: {
					self.searchText = ""
				}) {
					Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
				}
			}
			.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
			.foregroundColor(.secondary)
			.background(Color(.secondarySystemBackground))
			.cornerRadius(10.0)

			if showCancelButton  {
				Button("Cancel") {
						UIApplication.shared.endEditing(true)
						self.searchText = ""
						self.showCancelButton = false
				}
				.foregroundColor(Color(.systemBlue))
			}
		}
		.padding(.horizontal)
		.navigationBarHidden(showCancelButton)
	}
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
