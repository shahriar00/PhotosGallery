//
//  PhotoGalleryProvider.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import Foundation
import Combine

final class PhotoGalleryProvider: ObservableObject {
    
    static let shared = PhotoGalleryProvider()

    private var cancellables = Set<AnyCancellable>()
    
    @Published var photosResponse: ResponseState<[PhotosModel]> = .loading

    private let client = Client()
    
    func getPhotoGalleryData(page: Int, limit: Int) {
        
        photosResponse = .loading
        
        let queryParam = [
            "page": "\(page)",
            "limit": "\(limit)"
        ]
        
        let cancellable = client.photoData(.photos, queryParameters: queryParam)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self.photosResponse = .error(errorMessage: error.localizedDescription)
                }
            },
                receiveValue: { [self] response in
                self.photosResponse = .success(data: response)
            })
        cancellable.store(in: &cancellables)
    }
    
    func thumbnailURL(for photo: PhotosModel, size: CGSize = CGSize(width: 200, height: 200)) -> String {
        return "https://picsum.photos/id/\(photo.id)/\(Int(size.width))/\(Int(size.height))"
    }
    
    func fullSizeURL(for photo: PhotosModel) -> String {
        return photo.downloadUrl
    }
 
}
