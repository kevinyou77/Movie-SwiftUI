//
//  Date+ToString.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 05/08/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Foundation

struct DateHelper {
    
    static func convertDateToStringByLocale(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    static func convertStringToDateString(from string: String) -> String? {

        let dateFormatter = ISO8601DateFormatter()
        let releaseDate = dateFormatter.date(from: string)
        let localeString = Self.convertDateToStringByLocale(date: releaseDate ?? Date())
        
        return localeString
    }
}
