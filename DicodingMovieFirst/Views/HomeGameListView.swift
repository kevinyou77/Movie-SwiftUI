//
//  HomeGameListView.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import SwiftUI
import Combine

struct HomeGameListView: View {
	
	@State private var searchText = ""
	@State private var isLoading: Bool = false
	
	@Environment(\.imageCache) private var cache: ImageCache
	
	@ObservedObject private var viewModel: HomeGameListViewModel
	
    init(viewModel: HomeGameListViewModel = HomeGameListViewModel()) {
        
        self.viewModel = viewModel
		
		 UITableView.appearance().separatorColor = .clear
	}
	
    var body: some View {
		
		VStack {
			SearchBar(text: $searchText, onSearch: {
				self.isLoading = true
				self.viewModel.searchGames(self.searchText) {
					self.isLoading = false
				}
			})
			GameList(viewModel.games)
		}
		.onAppear(perform: {
			self.viewModel.searchGames(self.searchText)
		})
    }
}

extension HomeGameListView {
	
	private func GameList(_ gameList: [GameListDescription]) -> some View {
		
        let filteredGameListWithIndex = viewModel.games.enumerated().map { $0 }
		
		return Group {
			
			if isLoading {
				Text("Searching...")
			}
			
			if filteredGameListWithIndex.isEmpty {
				CommonUI.EmptyState(text: "No games found")
			}
			
			List(filteredGameListWithIndex, id: \.element.id) { (index, game) in
				self.GameDescription(index: index, game: game)
			}
			.padding(.horizontal, -20)
			.environment(\.defaultMinListRowHeight, 320)
		}
	}

	private func GameDescription(index: Int, game: GameListDescription) -> some View {
		
		Group {
			GameDescriptionView(index: index, game: game)
			NavigationLink(destination: GameDetailView(gameId: game.id, gameTitle: game.title)) {
				
				EmptyView()
			}
			.frame(width: 0)
			.opacity(0)
		}
	}
	
	private func GameDescriptionView(index: Int, game: GameListDescription) -> some View {
		
		let roundedGameRating = game.rating?.roundValueToString(toPlaces: "%.2f") ?? "N/A"
		let localizedDate = DateHelper.convertStringToDateString(from: game.releaseDate ?? "TBA")
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
			.padding(15)
		}
	}
	
	private func GameImageView(named imageName: String) -> some View {
		
		NetworkImageView(
			url: URL(string: imageName)!,
			cache: self.cache,
			placeholder: Text("Loading"),
			configuration: { $0.resizable() }
		)
		.aspectRatio(1.7, contentMode: .fill)
		.edgesIgnoringSafeArea(.all)
	}
}

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
	
	var onSearch: (() -> Void)

    func makeCoordinator() -> SearchBarCoordinator {
		return SearchBarCoordinator(text: _text, onSearch: onSearch)
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

class SearchBarCoordinator: NSObject, UISearchBarDelegate {

    private var cancellable: AnyCancellable?
    
    @Binding var text: String
    @Published var searchFieldText = ""
	
	var onSearch: (() -> Void)

	init(text: Binding<String>, onSearch: @escaping (() -> Void)) {
        _text = text
		self.onSearch = onSearch
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           
        searchFieldText = searchText
        cancellable = $searchFieldText
            .removeDuplicates()
            .debounce(for: 0.7, scheduler: DispatchQueue.main)
            .sink { debouncedValue in
                self.text = debouncedValue
				self.onSearch()
            }
    }
}
