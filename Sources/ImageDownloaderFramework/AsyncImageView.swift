//
//  AsyncImageView.swift
//  ImageDownloaderFramework
//
//  Created by Asaf Moav on 01/11/2025.
//


import SwiftUI
///Swift UI implementation
public struct AsyncImageView: UIViewRepresentable {
    let url: URL
    let placeholder: UIImage?
    
    public init(url: URL, placeholder: UIImage? = nil) {
        self.url = url
        self.placeholder = placeholder
    }
    
    public func makeUIView(context: Context) -> BestAsyncImageView {
        let imageView = BestAsyncImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
   public func updateUIView(_ uiView: BestAsyncImageView, context: Context) {
        uiView.load(url: url, placeholder: placeholder)
    }
}
