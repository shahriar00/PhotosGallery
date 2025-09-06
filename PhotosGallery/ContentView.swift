//
//  ContentView.swift
//  PhotosGallery
//
//  Created by Shahriar Islam Sazid on 9/6/25.
//

import SwiftUI
import UIPilot

struct ContentView: View {
    
    @StateObject var pilot = UIPilot(initial: AppRoute.PhotoGallery)
    
    var body: some View {
        
        VStack {
            
            RouteView(pilot: pilot)
                .navigationViewStyle(.stack)
                .navigationBarBackButtonHidden()
                .navigationBarHidden(true)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
