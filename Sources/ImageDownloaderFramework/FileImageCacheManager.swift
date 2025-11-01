//
//  FileImageCacheManager.swift
//  ImageDownloaderFramework
//
//  Created by Asaf Moav on 1/11/2025.
//
import UIKit

internal actor FileImageCacheManager {
    
    static let shared = FileImageCacheManager()
    private let cache: NSCache<NSURL, UIImage>
    private let fileManager = FileManager.default
    private let diskCacheURL: URL
    
    private init() {
        self.cache = NSCache()
        
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.diskCacheURL = cacheDirectory.appendingPathComponent("ImageCache", isDirectory: true)
        Task { await createCacheDirectory() }
    }
    
    private func createCacheDirectory() {
        if !fileManager.fileExists(atPath: diskCacheURL.path) {
            do {
                try fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating cache directory: \(error)")
            }
        }
    }
    
    func load(from url: URL) async throws -> UIImage {
        if let image = cache.object(forKey: url as NSURL) {
            return image
        }
        
        if let image = try? await loadFromDisk(url: url) {
            cache.setObject(image, forKey: url as NSURL)
            return image
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw BestError.decoding
            }
            
            cache.setObject(image, forKey: url as NSURL)
            try? await saveToDisk(data: data, url: url)
            
            return image
        } catch {
            if let error = error as? BestError {
                throw error
            } else {
                throw BestError.dataLoading(description: error.localizedDescription)
            }
        }
    }
    
    private func loadFromDisk(url: URL) async throws -> UIImage {
        let filename = url.absoluteString.toMD5()
        let fileURL = diskCacheURL.appendingPathComponent(filename)
        
        let data = try Data(contentsOf: fileURL)
        guard let image = UIImage(data: data) else {
            throw BestError.decoding
        }
        return image
    }
    
    private func saveToDisk(data: Data, url: URL) async throws {
        let filename = url.absoluteString.toMD5()
        let fileURL = diskCacheURL.appendingPathComponent(filename)
        try data.write(to: fileURL)
    }
    
    func contains(_ url: URL) -> Bool {
        if cache.object(forKey: url as NSURL) != nil {
            return true
        }
        
        let filename = url.absoluteString.toMD5()
        let fileURL = diskCacheURL.appendingPathComponent(filename)
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    func invalidateAll() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: diskCacheURL)
        try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
    }
    
    func invalidateMemoryCache() {
        cache.removeAllObjects()
    }
}

fileprivate extension String {
    func toMD5() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let hash = data.map { String(format: "%02hhx", $0) }.joined()
        return hash
    }
}
