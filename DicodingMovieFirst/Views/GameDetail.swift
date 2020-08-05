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
		return Text(description)
			.padding(
				EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20)
			)
	}
	
	private func GameInformation() -> some View {
		
		let platformInfo = viewModel.getPlatformInfo(from: viewModel.gameDetail.platforms)
		
        let releaseDateString = viewModel.gameDetail.released
        let localeString = DateHelper.convertStringToDateString(from: releaseDateString ?? "") ?? "TBA"
        
		return VStack(alignment: .leading) {
			
			Text(viewModel.gameDetail.name ?? "")
				.font(.largeTitle)
				.fontWeight(.bold)
			
			VStack(alignment: .leading) {
				Text("\(platformInfo)")
					.fontWeight(.bold)
                Text("Released \(localeString)")
					.font(.subheadline)
				Text("Metacritic: \(viewModel.gameDetail.metacritic ?? 0)/100")
					.font(.subheadline)
			}
		}
		.padding(
			EdgeInsets(top: 30, leading: 20, bottom: 10, trailing: 20)
		)
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
		GameDetailView(gameId: 3498, gameTitle: "a")
    }
}
