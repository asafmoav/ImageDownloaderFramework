//
//  ImageCacheManagerTests.swift
//  ImageDownloaderFrameworkTests
//
//  Created by Asaf Moav on 30/10/2025.
//

import XCTest

@testable import ImageDownloaderFramework

final class ImageCacheManagerTests: XCTestCase {
    
    let dataLoadingErrorUrl = "https://fastly.pisum.photos/id/1005/200/300.jpg?hmac=ZygrmRTuNYz9HivXcWqFGXDRVJxIHzaS-8MA0I3NKBw"
    let successUrl = "https://fastly.picsum.photos/id/1005/200/300.jpg?hmac=ZygrmRTuNYz9HivXcWqFGXDRVJxIHzaS-8MA0I3NKBw"
    let decodingErrorUrl = "https://fastly.picsum.photos/id/1005/200/300.jpg?hmac=ZygrmRTuNYz9HivXcWqFGDRVJxIHzaS-8MA0I3NKBw"
    
  
    func testCacheManagerInit() {
        let cacheManager = ImageCacheManager.shared
        XCTAssertNotNil(cacheManager)
    }
    
    func testCacheManagerLoadSuccess() {
        let url = URL(string: successUrl)!
        Task {
            let image = try? await ImageCacheManager.shared.load(from: url)
            XCTAssertNotNil(image)
        }
    }
    
    func testCacheManagerDataError() async {
        let url = URL(string: dataLoadingErrorUrl)!
        do {
            _ = try await ImageCacheManager.shared.load(from: url)
            XCTFail("Expected error but function succeeded")
        } catch let error as BestError {
            switch error {
            case .dataLoading:
                XCTAssert(true)
            default:
                XCTFail("Wrong error type: \(error.description)")
            }
        }catch {
            XCTFail("Wrong error: \(error.localizedDescription)")
        }
    }
    
    func testCacheManagerDecodingError() async {
        let url = URL(string: decodingErrorUrl)!
        do {
            _ = try await ImageCacheManager.shared.load(from: url)
            XCTFail("Expected error but function succeeded")
        } catch let error as BestError {
            switch error {
            case .decoding:
                XCTAssert(true)
            default:
                XCTFail("Wrong error type: \(error.description)")
            }
        }catch {
            XCTFail("Wrong error: \(error.localizedDescription)")
        }
    }
    
    func testLoadImageFromWeb() async {
        invalidateCache()
        let url = URL(string: successUrl)!
        XCTAssertFalse(ImageCacheManager.shared.contains(url))
        let image = try? await ImageCacheManager.shared.load(from: url)
        XCTAssertNotNil(image)
    }
    
    func testLoadImageFromCache() async {
        invalidateCache()
        let url = URL(string: successUrl)!
        XCTAssertFalse(ImageCacheManager.shared.contains(url))
        let image = try? await ImageCacheManager.shared.load(from: url)
        XCTAssertNotNil(image)
        
    }
    
    func testInvalidateCache() async {
        invalidateCache()
        let url = URL(string: successUrl)!
        XCTAssertFalse(ImageCacheManager.shared.contains(url))
        let image = try? await ImageCacheManager.shared.load(from: url)
        XCTAssertNotNil(image)
        XCTAssertTrue(ImageCacheManager.shared.contains(url))
        ImageCacheManager.shared.invalidateAll()
        XCTAssertFalse(ImageCacheManager.shared.contains(url))
    }
    
    private func invalidateCache() {
        ImageCacheManager.shared.invalidateAll()
    }
}
