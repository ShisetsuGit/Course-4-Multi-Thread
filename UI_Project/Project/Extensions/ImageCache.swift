//
//  ImageCache.swift
//  UI_Project
//
//  Created by Shisetsu on 06.07.2021.
//
// MARK: - Extesion for image caching

import Kingfisher

func imageCache(url: String, completion: @escaping(UIImage)->()) {
    
    let imageUrl = URL(string: url)!
    KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
        let image = try? result.get().image
        if let image = image {
            completion(image)
        }
    }
}
