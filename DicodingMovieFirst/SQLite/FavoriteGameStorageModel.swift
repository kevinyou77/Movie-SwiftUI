//
//  FavoriteGameStorageModel.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 29/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Foundation
import SQLite

private struct FavoriteGameTableColumns {
	
	let gameId = Expression<String?>("gameId")
	let title = Expression<String?>("title")
	let ratingsCount = Expression<Int?>("ratingsCount")
	let rating = Expression<Double?>("rating")
	let rank = Expression<String?>("rank")
	let releaseDate = Expression<String?>("releaseDate")
	let cover = Expression<String?>("cover")
	let favorited = Expression<Bool?>("favorited")
}

final class FavoriteGameStorageModel {
	
	static let shared: FavoriteGameStorageModel = FavoriteGameStorageModel()
	
	var connection: Connection?
	
	private var favoriteGameTable: Table?
	
	private let favoriteGameTableName: String = "favorite_game"
	private let favoriteGameTableColumns: FavoriteGameTableColumns = FavoriteGameTableColumns()
	
	private init() {
		try? prepare()
	}
	
	func prepare() throws {
		
		try createConnection()
		try createTable()
	}
	
	private func createConnection() throws {
		
		let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		
		guard let validPath = paths.first else {
			fatalError("Cannot open SQLite connection")
		}
		
		self.connection = try Connection("\(validPath)/\(favoriteGameTableName).sqlite3")
	}
	
	private func createTable() throws {
		
		favoriteGameTable = Table(favoriteGameTableName)
		
		let createTableQuery = favoriteGameTable?.create(ifNotExists: true) { (builder: TableBuilder) in
			
			builder.column(favoriteGameTableColumns.gameId)
			builder.column(favoriteGameTableColumns.cover)
			builder.column(favoriteGameTableColumns.rank)
			builder.column(favoriteGameTableColumns.rating)
			builder.column(favoriteGameTableColumns.ratingsCount)
			builder.column(favoriteGameTableColumns.releaseDate)
			builder.column(favoriteGameTableColumns.title)
			builder.column(favoriteGameTableColumns.favorited)
		}
		
		guard let query = createTableQuery else {
			fatalError("Query not valid")
		}
		
		do {
			try connection?.run(query)
		} catch {
			fatalError("Failed to run query")
		}
	}
	
	func getFavoriteGames() -> [GameListDescription] {
		
		do {
			return try _getFavoriteGames()
		} catch {
			print("Error on getting favorite list: \(error)")
			return []
		}
	}
	
	func insertFavoriteGame(item: GameListDescription) -> Bool {

		do {
			return try _insertFavoriteGame(item: item)
		} catch {
			print("Error on insert to favorite: \(error)")
			return false
		}
	}
	
	private func _getFavoriteGames() throws -> [GameListDescription] {
		
		guard
			let connection = connection,
			let table = favoriteGameTable else {

				return []
		}
		
		let rows = try connection.prepare(table)
		
		return rows.map { (row) -> GameListDescription in
			
			do {
				
				var description = GameListDescription()
				description.gameId = try row.get(self.favoriteGameTableColumns.gameId) ?? ""
				description.cover = try row.get(self.favoriteGameTableColumns.cover) ?? ""
				description.ratingsCount = try row.get(self.favoriteGameTableColumns.ratingsCount) ?? 0
				description.rating = try row.get(self.favoriteGameTableColumns.rating) ?? 0.0
				description.rank = try row.get(self.favoriteGameTableColumns.rank) ?? ""
				description.releaseDate = try row.get(self.favoriteGameTableColumns.releaseDate) ?? ""
				description.favorited = try row.get(self.favoriteGameTableColumns.favorited) ?? false
				
				return description
			} catch {
				return GameListDescription()
			}
		}
	}
	
	private func _insertFavoriteGame(item: GameListDescription) throws -> Bool {

		guard
			let connection = connection,
			let table = favoriteGameTable else {
				return false
		}
		
		do {
			
			let query = table.insert(
				favoriteGameTableColumns.cover <- item.cover,
				favoriteGameTableColumns.gameId <- item.gameId,
				favoriteGameTableColumns.rank <- item.rank,
				favoriteGameTableColumns.rating <- item.rating,
				favoriteGameTableColumns.ratingsCount <- item.ratingsCount,
				favoriteGameTableColumns.title <- item.title,
				favoriteGameTableColumns.releaseDate <- item.releaseDate,
				favoriteGameTableColumns.favorited <- item.favorited
			)

			try connection.run(query)
			
			return true
		} catch {
			
			return false
		}
		
	}
}
