//
//  APIFeed.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import Foundation

enum ApiFeed {
    case photos
}

extension ApiFeed: Endpoint {
    
    
    var base: String {
        return "https://picsum.photos"
    }
    
    
    var path: String {
        switch self {
        case .photos: return "/v2/list"
        }
    }
}
