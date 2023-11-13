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
            .font(.title)
        }
    }
    
    func movieDetails() -> some View  {
        let URLString = "https://image.tmdb.org/t/p/w500"
        
        return VStack {

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
                    NavigationLink(destination: FullScreenImageView(imageUrl: posterURL, imageLoader: ImageLoader(url: posterURL))) {
                        URLImage(url: posterURL)
                            .scaledToFit()
                            .frame(width: 120, height : 200)
                            .foregroundColor(.black)
                    }
                }
            }
            Text("Overview: \(movie.overview)")
                .font(.headline)
                .foregroundColor(.black)
                .padding(20)
            if let backdropPath = movie.backdrop_path,
               let posterURL = URL(string: URLString + backdropPath) {
                NavigationLink(destination: FullScreenImageView(imageUrl: posterURL, imageLoader: ImageLoader(url: posterURL))) {
                    URLImage(url: posterURL)
                        .scaledToFit()
                        .frame(height: 200)
                        .foregroundColor(.black)
                }
            } else {
                Image(systemName: "photo")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .infinity, height: 200)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .foregroundColor(.black)
            }
        }
    }
}
