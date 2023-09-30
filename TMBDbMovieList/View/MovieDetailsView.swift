//
//  MovieDetailsView.swift
//  TMBDbMovieList
//
//  Created by Auto on 9/30/23.
//

import SwiftUI

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieViewModel
    let movie: Movie
    @Environment(\.presentationMode) var presentationMode
    @State private var isPosterFullScreen = false
    @State private var isBackdropFullScreen = false
    @State private var isFullScreen = false
    
    
    var body: some View {
        ZStack {
            Color("secondary")
                .edgesIgnoringSafeArea(.all)
            ScrollView{
                movieDetails()
            }
            .navigationTitle(movie.title)
            .navigationBarTitleDisplayMode(.inline)
            .font(.title)
        }
    }
    
    func movieDetails() -> some View  {
        let URLString = "https://image.tmdb.org/t/p/w500"
        
        return VStack {
            Text("Title: \(movie.title)")
                .fontWeight(.bold)
                .font(.title)
                .multilineTextAlignment(.center)
            HStack {
                VStack(alignment: .leading) {
                    Text("Language: \(movie.original_language)")
                        .font(.headline)
                    Text(String(format: "Rating: %.1f/10", movie.vote_average))
                        .font(.headline)
                    Text("Vote Count: \(movie.vote_count)")
                        .font(.headline)
                    Text(String(format: "Popularity: %.3f", movie.popularity))
                        .font(.headline)
                    Text("Release Date: \(movie.release_date)")
                        .font(.headline)
                }
                if let posterPath = movie.poster_path,
                   let posterURL = URL(string: URLString + posterPath) {
                    NavigationLink(destination: FullScreenImageView(isFullScreen: $isPosterFullScreen, imageUrl: posterURL, imageLoader: ImageLoader(url: posterURL))) {
                        URLImage(url: posterURL)
                            .scaledToFit()
                            .frame(width: isPosterFullScreen ? UIScreen.main.bounds.width : 120,
                                   height: isPosterFullScreen ? UIScreen.main.bounds.height : 200)
                    }
                }
            }
            Text("Overview: \(movie.overview)")
                .font(.headline)
                .foregroundColor(.black)
            //            .overlay(
            //                RoundedRectangle(cornerRadius: 10)
            //                    .stroke(Color.black, lineWidth: 2)
            //            )
                .padding(20)
            if let backdropPath = movie.backdrop_path,
               let posterURL = URL(string: URLString + backdropPath) {
                NavigationLink(destination: FullScreenImageView(isFullScreen: $isBackdropFullScreen, imageUrl: posterURL, imageLoader: ImageLoader(url: posterURL))) {
                    URLImage(url: posterURL)
                        .scaledToFit()
                        .frame(height: isPosterFullScreen ? UIScreen.main.bounds.height : 200)
                }
            } else {
                Image(systemName: "photo")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .infinity, height: 200)
                    .cornerRadius(10)
                    .padding(.top, 10)
            }
        }
    }
    
}

struct FullScreenImageView: View {
    @Binding var isFullScreen: Bool
    let imageUrl: URL
    @ObservedObject var imageLoader: ImageLoader
    
    var body: some View {
        ZStack {
            Color("secondary")
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 200)
            if let uiImage = imageLoader.image {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .frame(width: .infinity, height: .infinity)
                    .padding()
            }
        }
        .onAppear {
            imageLoader.loadImage(from: imageUrl)
        }
    }
}
