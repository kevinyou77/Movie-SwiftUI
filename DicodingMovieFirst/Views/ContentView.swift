//
//  ContentView.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 17/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
		
		TabView {
			NavigationView {
				
				HomeGameListView()
					.navigationBarTitle("Games", displayMode: .automatic)
					.navigationBarItems(trailing: AboutButton())
			}
			.tabItem {
			   Image(systemName: "list.dash")
			   Text("Menu")
			}
			
			NavigationView {
				
				FavoriteGamesView()
					.navigationBarTitle("Favorites", displayMode: .automatic)
			}
			.tabItem {
			   Image(systemName: "star.fill")
			   Text("Favorites")
			}
		}
    }
}

extension ContentView {
	
	private func AboutButton() -> some View {
		
		NavigationLink(destination: AboutView()) {
			Text("About")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
