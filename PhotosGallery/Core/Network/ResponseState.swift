//
//  ResponseState.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import Foundation

enum ResponseState<T> {
    case loading
    case error(errorMessage: String?)
    case success(data: T)
}
