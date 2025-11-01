//
//  BestAsyncImageViewTests.swift
//  ImageDownloaderFrameworkTests
//
//  Created by Asaf Moav on 31/10/2025.
//

import XCTest

@testable import ImageDownloaderFramework
@MainActor
final class BestAsyncImageViewTests: XCTestCase {
    
    let placeholderImage = UIImage(systemName: "photo")
    let errorUrl = "https://pic-sum.photos/300"
    let successUrl = "https://picsum.photos/300"
    
    
    func testImageLoadingSuccess() {
        let sut = BestAsyncImageView()
        let url = URL(string: successUrl)!
        XCTAssertNil(sut.image)
        let expectation = expectation(description: "Image loads")
        
        sut.load(url: url)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if sut.image != nil {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(sut.image)
    }
    
    func testPlaceholerSuccess() {
        let sut = BestAsyncImageView()
        let url = URL(string: errorUrl)!
        XCTAssert(sut.image == nil)
        sut.load(url: url, placeholder: placeholderImage)
        XCTAssert(sut.image == placeholderImage)
    }
}

