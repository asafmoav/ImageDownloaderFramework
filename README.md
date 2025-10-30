# ImageDownloaderFramework
a library to download and present images

ImageLoaderKit/
 └─ Sources/
     └─ ImageLoaderKit/
         ├─ AsyncImageView.swift
         ├─ ImageCache.swift
         └─ ImageLoader.swift


         import UIKit

public protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

public final class DefaultImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    public init() {}

    public subscript(_ url: URL) -> UIImage? {
        get { cache.object(forKey: url as NSURL) }
        set {
            if let newValue = newValue {
                cache.setObject(newValue, forKey: url as NSURL)
            } else {
                cache.removeObject(forKey: url as NSURL)
            }
        }
    }
}




import UIKit

public final class ImageLoader {
    public static let shared = ImageLoader()

    private let cache: ImageCache

    public init(cache: ImageCache = DefaultImageCache()) {
        self.cache = cache
    }

    public func load(from url: URL) async throws -> UIImage {
        if let cached = cache[url] { return cached }

        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.badServerResponse)
        }

        cache[url] = image
        return image
    }
}

import UIKit

public final class AsyncImageView: UIImageView {

    private var currentTask: Task<Void, Never>?

    public func load(url: URL, placeholder: UIImage? = nil) {
        image = placeholder
        currentTask?.cancel()

        currentTask = Task { [weak self] in
            do {
                let img = try await ImageLoader.shared.load(from: url)
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
