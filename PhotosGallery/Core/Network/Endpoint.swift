//
//  Endpoint.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
}
extension Endpoint {
    
    var urlComponents: URLComponents {
        print("baseurl: \(base)")
        var components = URLComponents(string: base)!
        components.path = path
        return components
    }
    
    var request: URLRequest {
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        
                return urlRequest
        
    }
    
}

