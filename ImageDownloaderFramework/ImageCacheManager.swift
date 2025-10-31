//
//  ImageCacheManager.swift
//  ImageDownloaderFramework
//
//  Created by Asaf Moav on 31/10/2025.
//
import Foundation
import UIKit

public struct BestImageCacheHelper {
    public static func invalidateAll() {
        ImageCacheManager.shared.invalidateAll()
    }
}

class ImageCacheManager {
    
    public static let shared = ImageCacheManager()
    private let cache: NSCache<NSURL, UIImage>
        
    private init() { self.cache = NSCache()}
    
    func load(from url: URL) async throws -> UIImage {
        if let image = cache.object(forKey: url as NSURL) {
            return image
        }
        
        let (data,_) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            //TODO: error handling
            throw NSError(domain: "ImageDecodingError", code: 0, userInfo: nil)
        }
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
    
    func invalidateAll() {
        cache.removeAllObjects()
    }
}
