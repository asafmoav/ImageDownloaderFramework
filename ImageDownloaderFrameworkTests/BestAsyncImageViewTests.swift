//
//  BestAsyncImageViewTests.swift
//  ImageDownloaderFrameworkTests
//
//  Created by Asaf Moav on 31/10/2025.
//

import XCTest

@testable import ImageDownloaderFramework

final class BestAsyncImageViewTests: XCTestCase {
    
    let placeholderImage = UIImage(named: "placeholder")
    let errorUrl = "https://fastly.pisum.photos/id/1005/200/300.jpg?hmac=ZygrmRTuNYz9HivXcWqFGXDRVJxIHzaS-8MA0I3NKBw"
    let successUrl = "https://fastly.picsum.photos/id/1005/200/300.jpg?hmac=ZygrmRTuNYz9HivXcWqFGXDRVJxIHzaS-8MA0I3NKBw"
    
    
    
    func testImageLoadingSuccess() {
        let sut = BestAsyncImageView()
        let url = URL(string: successUrl)!
        XCTAssertNil(sut.image)
        let expectation = expectation(description: "Image loads")
        
        sut.load(url: url)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if sut.image != nil {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
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

