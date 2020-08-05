//
//  ImageCache.swift
//  DicodingMovieFirst
//
//  Created by Kevin Yulias on 18/07/20.
//  Copyright © 2020 Kevin Yulias. All rights reserved.
//

import UIKit

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        
        get { cache.object(forKey: key as NSURL) }

        set {
            
            if newValue != nil {
                cache.setObject(newValue!, forKey: key as NSURL)
                return
            }
            
            cache.removeObject(forKey: key as NSURL)
        }
    }
}
