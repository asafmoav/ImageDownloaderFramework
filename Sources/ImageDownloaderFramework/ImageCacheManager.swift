//
//  ImageCacheManager.swift
//  ImageDownloaderFramework
//
//  Created by Asaf Moav on 31/10/2025.
//
import Foundation
import UIKit

internal class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    private let cache: NSCache<NSURL, UIImage>
        
    private init() { self.cache = NSCache()}
    
    func load(from url: URL) async throws -> UIImage {
        if let image = cache.object(forKey: url as NSURL) {
            return image
        }
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw BestError.decoding
            }
            cache.setObject(image, forKey: url as NSURL)
            return image
        } catch {
            if let error = error as? BestError {
                throw error
            } else {
                throw BestError.dataLoading(description: error.localizedDescription)
            }
        }
    }
    
    func contains(_ url: URL) -> Bool {
        cache.object(forKey: url as NSURL) != nil
    }
    
    func invalidateAll() {
        cache.removeAllObjects()
    }
}
