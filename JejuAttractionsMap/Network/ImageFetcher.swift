//
//  ImageFetcher.swift
//  JejuAttractionsMap
//
//  Created by 김남건 on 2023/04/22.
//

import UIKit

class ImageFetcher {
    private let cache = NSCache<NSString, UIImage>()
    
    func fetchImage(for attractionName: String) async throws -> UIImage {
        if let image = cache.object(forKey: NSString(string: attractionName)) {
            return image
        }
        
        let imageUrlString = try await NetworkManager().fetchImageURLString(for: attractionName)
        let image = try await NetworkManager().fetchImage(from: imageUrlString)
        
        cache.setObject(image, forKey: NSString(string: attractionName))
        
        return image
    }
}
