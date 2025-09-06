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
            
             HStack {
                 Text("Photos Gallery")
                     .font(.title2)
                     .fontWeight(.semibold)
                     .foregroundColor(.primary)
                 
                 Spacer()
                 
                 Button(action: {
                     photoGalleryProvider.getPhotoGalleryData(page: 1, limit: 60)
                 }) {
                     Image(systemName: "arrow.clockwise")
                         .foregroundColor(.blue)
                 }
             }
             .padding()
             .background(Color(.systemGray6))
             .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
             
             Divider()
            
            switch photoGalleryProvider.photosResponse {
                
            case .loading:

                VStack {
                    
                    Spacer()
                    
                    ProgressView("Loading photos...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(2.0)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) 

                
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
                                        pilot.push(.ImageDetailView(imageURL:  photo.downloadUrl, photo: photo))
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
