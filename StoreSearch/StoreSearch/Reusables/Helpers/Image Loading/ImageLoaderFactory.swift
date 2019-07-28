//
//  ImageLoaderFactory.swift
//  StoreSearch
//
//  Created by Brian Sipple on 7/27/19.
//  Copyright © 2019 CypherPoet. All rights reserved.
//

import Foundation

final class ImageLoaderFactory {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    func makeImageLoader() -> ImageLoader {
        return SessionImageLoader(session: session)
    }
}
