//
//  BestImageCacheHelper.swift
//  ImageDownloaderFramework
//
//  Created by Asaf Moav on 31/10/2025.
//

public struct BestImageCacheHelper {
    public static func invalidateAll() async {
        await ImageCacheManager.shared.invalidateAll()
    }
}
