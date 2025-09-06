//
//  PhotoGalleryProviderTests.swift
//  PhotosGalleryTests
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import XCTest
@testable import PhotosGallery


final class PhotoGalleryProviderTests: XCTestCase {
   
    var photoProvider: PhotoGalleryProvider!
    
    override func setUp() {
        photoProvider = PhotoGalleryProvider()
    }
    
    override func tearDown() {
        photoProvider = nil
    }
    
    // TEST CASE 1: Test thumbnail URL generation
    func testThumbnailURLCreation() {
        
        let testPhoto = PhotosModel(
            id: "19",
            author: "Paul Jarvis",
            width: 2500,
            height: 1667,
            url: "https://unsplash.com/photos/P7Lh0usGcuk",
            downloadUrl: "https://picsum.photos/id/19/2500/1667"
        )
        
        let result = photoProvider.thumbnailURL(for: testPhoto)
        
        let expected = "https://picsum.photos/id/19/200/200"
        XCTAssertEqual(result, expected, "Thumbnail URL should match expected format")
        
        print("Test passed! Generated URL: \(result)")
    }
    
    // TEST CASE 2: Test full size URL
    func testFullSizeURL() {
        
        let testPhoto = PhotosModel(
            id: "20",
            author: "Aleks Dorohovich",
            width: 3670,
            height: 2462,
            url: "https://unsplash.com/photos/nJdwUHmaY8A",
            downloadUrl: "https://picsum.photos/id/20/3670/2462"
        )
        
        let result = photoProvider.fullSizeURL(for: testPhoto)
        
        let expected = "https://picsum.photos/id/20/3670/2462"
        XCTAssertEqual(result, expected, "Full size URL should return download URL")
        
        print("Test passed! Full size URL: \(result)")
    }
    

    func testCustomThumbnailSize() {
        
        let testPhoto = PhotosModel(
            id: "19",
            author: "Paul Jarvis",
            width: 2500,
            height: 1667,
            url: "https://unsplash.com/photos/P7Lh0usGcuk",
            downloadUrl: "https://picsum.photos/id/19/2500/1667"
        )
        
        let customSize = CGSize(width: 300, height: 300)
        
        let result = photoProvider.thumbnailURL(for: testPhoto, size: customSize)
        
        let expected = "https://picsum.photos/id/19/300/300"
        XCTAssertEqual(result, expected, "Should generate URL with custom size")
        
        print("Test passed! Custom size URL: \(result)")
    }
}
