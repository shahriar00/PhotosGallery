//
//  PhotoGalleryView.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import SwiftUI
import UIPilot

struct PhotoGalleryView: View {

    @ObservedObject var photoGalleryProvider = PhotoGalleryProvider.shared
    
    @EnvironmentObject var pilot: UIPilot<AppRoute>
    
    private let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    @State private var hasLoadedInitialData = false
    
    var body: some View {
        
        VStack{
            
            switch photoGalleryProvider.photosResponse {
                
            case .loading:
                
                Spacer()
                    .frame(height: 100)
      
                
                ProgressView("Loading photos...")
                    .padding()
                
            case .error(_):
                
                EmptyView()
                
            case .success(let data):
                if data.isEmpty {
                   Text("Data Not Found at this moment")
                } else {
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 2) {
                            ForEach(data) { photo in
                                PhotoGridCells(photo: photo, viewModel: photoGalleryProvider)
                                    .onTapGesture {
                                       
                                    }
                                    
                            }
                        }
                        .padding(.horizontal, 2)
                        
                        
                    }
                }
                
            }
            
            Spacer()
        }
        .onAppear {
            if !hasLoadedInitialData {
                photoGalleryProvider.getPhotoGalleryData(page: 1, limit: 60)
                hasLoadedInitialData = true
            }
        }


    }

}

#Preview {
    PhotoGalleryView()
}
