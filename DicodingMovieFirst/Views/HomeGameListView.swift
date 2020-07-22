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
	
	@Environment(\.imageCache) private var cache: ImageCache
	
	@ObservedObject private var viewModel: HomeGameListViewModel = HomeGameListViewModel()
	
	init() {
		
		 UITableView.appearance().separatorColor = .clear
	}
	
    var body: some View {
		
		VStack {
			SearchBar(text: $searchText)
			GameList(viewModel.games)
		}
    }
}

extension HomeGameListView {
	
	private func GameList(_ gameList: [GameListDescription]) -> some View {
		
		let filteredGameList = gameList.filter { game in
			self.searchText.isEmpty ? true : game.title.lowercased().contains(self.searchText)
		}
		
		return List(filteredGameList) {
			self.GameDescription(game: $0)
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
				
				Text("Released \(game.releaseDate)")
					.font(.caption)
			}
			.padding(7)
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

struct SearchBar: UIViewRepresentable {

    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {

        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
		searchBar.autocapitalizationType = .none
		searchBar.placeholder = "Search"
		
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
