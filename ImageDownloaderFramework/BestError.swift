//
//  BestError.swift
//  ImageDownloaderFramework
//
//  Created by Asaf Moav on 31/10/2025.
//

internal enum BestError: Error, Equatable
{
    case decoding
    case dataLoading(description: String)
    
    var description: String {
        let d = "BestImageDownloaderError - "
        switch self {
        case .decoding:
            return d + "ImageDecodingError"
        case .dataLoading(let desc):
            return d + "DataLoadingError:\n\(desc)"
        }
    }
}

