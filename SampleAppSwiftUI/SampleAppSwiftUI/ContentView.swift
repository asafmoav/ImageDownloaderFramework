//
//  ContentView.swift
//  SampleAppSwiftUI
//
//  Created by Asaf Moav on 01/11/2025.
//

import SwiftUI
import ImageDownloaderFramework

struct ContentView: View {
    var body: some View {
        AsyncImageView(
                    url: URL(string: "https://picsum.photos/300")!,
                    placeholder: UIImage(systemName: "photo")
                )
                .frame(width: 200, height: 200)
                .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}
