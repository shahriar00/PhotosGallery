//
//  ImageDetailView.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//
import SwiftUI
import Kingfisher
import UIKit
import Photos

struct ImageDetailView: View {
    let imageURL: String
    let photo: PhotosModel
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var showingShareSheet = false
    @State private var showingSaveAlert = false
    @State private var saveMessage = ""
    @State private var currentImage: UIImage?
    @State private var imageSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                KFImage(URL(string: imageURL))
                    .onSuccess { result in
                        currentImage = result.image
                        imageSize = result.image.size
                    }
                    .placeholder {
                        ProgressView()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(limitOffset(offset, geometry: geometry))
                    .gesture(
                        SimultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    let newScale = lastScale * value
                                    scale = min(max(newScale, 0.5), 5.0)
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                    if scale < 1.0 {
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                            scale = 1.0
                                            lastScale = 1.0
                                            offset = .zero
                                            lastOffset = .zero
                                        }
                                    } else {
                            
                                        let limitedOffset = limitOffset(offset, geometry: geometry)
                                        if limitedOffset != offset {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                offset = limitedOffset
                                                lastOffset = limitedOffset
                                            }
                                        }
                                    }
                                },
                            
                            DragGesture()
                                .onChanged { value in
                                    let newOffset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                    offset = limitOffset(newOffset, geometry: geometry)
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                    )
                    .onTapGesture(count: 2) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            if scale > 1.0 {
                                scale = 1.0
                                lastScale = 1.0
                                offset = .zero
                                lastOffset = .zero
                            } else {
                                scale = 2.0
                                lastScale = 2.0
                                offset = .zero
                                lastOffset = .zero
                            }
                        }
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        
  
    }
    

    private func limitOffset(_ proposedOffset: CGSize, geometry: GeometryProxy) -> CGSize {
        guard scale > 1.0, imageSize != .zero else {
            return .zero
        }
        
        // Calculate the actual image display size
        let aspectRatio = imageSize.width / imageSize.height
        let containerAspectRatio = geometry.size.width / geometry.size.height
        
        let displayWidth: CGFloat
        let displayHeight: CGFloat
        
        if aspectRatio > containerAspectRatio {
            // Image is wider - fit to width
            displayWidth = geometry.size.width
            displayHeight = geometry.size.width / aspectRatio
        } else {
            // Image is taller - fit to height
            displayHeight = geometry.size.height
            displayWidth = geometry.size.height * aspectRatio
        }
        
        // Calculate scaled dimensions
        let scaledWidth = displayWidth * scale
        let scaledHeight = displayHeight * scale
        
        // Calculate maximum allowed offset
        let maxOffsetX = max(0, (scaledWidth - geometry.size.width) / 2)
        let maxOffsetY = max(0, (scaledHeight - geometry.size.height) / 2)
        
        return CGSize(
            width: max(-maxOffsetX, min(maxOffsetX, proposedOffset.width)),
            height: max(-maxOffsetY, min(maxOffsetY, proposedOffset.height))
        )
    }
    

}

