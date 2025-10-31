//
//  BestAsyncImageView.swift
//  BestAsyncImageView
//
//  Created by Asaf Moav on 30/10/2025.
//

import UIKit
public final class BestAsyncImageView: UIImageView {

    private var currentTask: Task<Void, Never>?
    
    deinit {
        currentTask?.cancel()
    }
    
    public func load(url: URL, placeholder: UIImage? = nil) {
        image = placeholder
        currentTask?.cancel()

        currentTask = Task { [weak self] in
            do {
                let img = try await ImageCacheManager.shared.load(from: url)
                await MainActor.run {
                    self?.image = img
                }
            } catch {
                //TODO: error handling
                print((error as? BestError)?.description ?? "Unknown Error")
            }
        }
    }
}
