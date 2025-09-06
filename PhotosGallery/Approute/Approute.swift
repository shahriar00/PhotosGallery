//
//  Approute.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import Foundation
import SwiftUI
import UIPilot

enum AppRoute: Equatable {
    case PhotoGallery
    case ImageDetailView(imageURL: String, photo: PhotosModel)
}

struct RouteView: View {
    
    let pilot: UIPilot<AppRoute>

    var body: some View {
        
        ZStack{
           
                UIPilotHost(pilot) { route in

                    switch route {
                        
                    case .PhotoGallery: PhotoGalleryView()
                        
                    case .ImageDetailView(let imageURL,let photo): ImageDetailView(imageURL: imageURL, photo: photo)
                        
                    }
                }
            }
    }
}
