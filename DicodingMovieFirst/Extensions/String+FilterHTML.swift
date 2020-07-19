//
//  String+FilterHTML.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 19/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import Foundation

extension String {

    func eraseAllHTMLTags() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
			
            let attributed = try NSAttributedString(
				data: data,
				options: [
					.documentType: NSAttributedString.DocumentType.html,
					.characterEncoding: String.Encoding.utf8.rawValue
				],
				documentAttributes: nil
			)

            return attributed.string
        } catch {
            return nil
        }
    }
}
