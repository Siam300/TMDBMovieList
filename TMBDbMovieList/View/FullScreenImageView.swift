//
//  FullScreenImageView.swift
//  TMBDbMovieList
//
//  Created by Auto on 10/2/23.
//

import SwiftUI

struct FullScreenImageView: View {
    let imageUrl: URL
    @ObservedObject var imageLoader: ImageLoader
    @State private var shouldAnimate = false
    @Namespace var animation
    
    var body: some View {
        ZStack {
            Color("secondary")
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 200)
            
            if let uiImage = imageLoader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .matchedGeometryEffect(id: "shape", in: animation)
                    .frame(maxWidth: shouldAnimate ? .infinity : 200, maxHeight: shouldAnimate ? .infinity : 200)
                    .padding(5)
                    .transition(.asymmetric(insertion: .identity, removal: .opacity))
                    .foregroundColor(.black)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                shouldAnimate = true
                            }
                        }
                    }
            }
        }
    }
}
