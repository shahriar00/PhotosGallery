//
//  ErrorMessage.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import SwiftUI

struct ErrorMessage: View {
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.red)
                
                Text("Failed to load photos")
                    .font(.headline)
                    .foregroundColor(.primary)
                
            }
            .padding()
            .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) 
    }
}

#Preview {
    ErrorMessage()
}
