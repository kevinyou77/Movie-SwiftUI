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
	
	@ObservedObject var viewModel: GameDetailViewModel
	
	init(gameId: Int, gameTitle: String) {

		self.gameId = gameId
		self.gameTitle = gameTitle
		self.viewModel = GameDetailViewModel(id: gameId)

		UINavigationBar.appearance().barTintColor = .clear
		UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
	}
	
	var body: some View {
		MainStack()
			.navigationBarTitle(Text(gameTitle), displayMode: .inline)
			.navigationBarHidden(false)
 	}
	
	private func MainStack() -> some View {
		
		ScrollView(.vertical) {
			
			ScreenshotHorizontalScrollView(screenshots: [String]())
			GameInformation()
			GameDescription()
		}
		.onAppear(perform: {
			self.viewModel.getGameDetail(by: self.gameId)
		})
	}
}

extension GameDetailView {
	
	private func GameDescription() -> some View {
		
		let description = viewModel.gameDetail.gameDetailDescription ?? ""
		return Text(description).padding(20)
	}
	
	private func GameInformation() -> some View {
		
		VStack(alignment: .leading) {
			
			Text(viewModel.gameDetail.name ?? "")
				.font(.largeTitle)
				.fontWeight(.bold)
			
			VStack(alignment: .leading) {
				Text("Released \(viewModel.gameDetail.released ?? "")")
				Text("\(viewModel.gameDetail.metacritic ?? 0)")
				Text("PC, XBOX ONE, PS4")
			}
		}
		.padding(20)
		.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	private func ScreenshotHorizontalScrollView(screenshots: [String]) -> some View {
		
		ScrollView(.horizontal) {
			
			HStack(alignment: .bottom, spacing: 5) {
				ForEach(0..<10) {
					Text("Item \($0)")
						.foregroundColor(.white)
						.font(.largeTitle)
						.frame(width: 200, height: 200)
						.background(Color.red)
				}
			}
		}
	}
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
		GameDetailView(gameId: 3498, gameTitle: "a")
    }
}
