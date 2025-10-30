//
//  BestAsyncImageView.swift
//  ImageDownloaderFramework
//
//  Created by Asaf Moav on 30/10/2025.
//

import UIKit
public final class AsyncImageView: UIImageView {

    private var currentTask: Task<Void, Never>?

    public func load(url: URL, placeholder: UIImage? = nil) {
        image = placeholder
        currentTask?.cancel()

        currentTask = Task { [weak self] in
            do {
                let img = try await ImageCacheManager.shared.load(from: url)
                await MainActor.run { self?.image = img }
            } catch {
                // Optionally add logging or delegate error callback
            }
        }
    }
    deinit {
        currentTask?.cancel()
    }
}



fileprivate class ImageCacheManager {
    
    public static let shared = ImageCacheManager()
    private let cache: NSCache<NSURL, UIImage>
        
    private init() { self.cache = NSCache()}
    func load(from url: URL) async throws -> UIImage {
        if let image = cache.object(forKey: url as NSURL) {
            return image
        }
        
        let (data,_) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageDecodingError", code: 0, userInfo: nil)
        }
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}
