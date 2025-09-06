//
//  PhotoGridCell.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import SwiftUI
import Kingfisher

struct PhotoGridCells: View {
    let photo: PhotosModel
    let viewModel: PhotoGalleryProvider
    
    var body: some View {
        KFImage(URL(string: viewModel.thumbnailURL(for: photo)))
            .placeholder {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2))
            }
            .resizable()
            .aspectRatio(1, contentMode: .fill)
            .clipped()
            .overlay(
                LinearGradient(
                    colors: [.clear, .black.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Text(photo.author)
                            .font(.caption)
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        Spacer()
                    }
                    .padding(.horizontal, 4)
                    .padding(.bottom, 2)
                }
            )
    }
}


