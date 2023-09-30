//
//  MovieList.swift
//  TMBDbMovieList
//
//  Created by Auto on 8/18/23.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var selectedMovie: Movie?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("primary")
                    .edgesIgnoringSafeArea(.all)
                List {
                    ForEach(viewModel.movies.indices, id: \.self) { index in
                        let movie = viewModel.movies[index]
                        NavigationLink(destination: MovieDetailsView(viewModel: viewModel, movie: movie)) {
                            MovieView(movie: movie, index: index)
                        }
                    }
                    .listRowBackground(Color("primary"))
                }
                .padding(0)
                .navigationBarTitle("Top 20 Movies")
            }
        }
        .listStyle(PlainListStyle())
    }
    
    func MovieView(movie: Movie, index: Int) -> some View {
        let URLString = "https://image.tmdb.org/t/p/w500"
        return HStack {
            if let posterPath = movie.poster_path,
               let posterURL = URL(string: URLString + posterPath) {
                URLImage(url: posterURL)
                    .frame(width: 140, height: 200)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 200)
            }
            LazyVStack(alignment: .leading) {
                Text("Ranking: \(index + 1).")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(.trailing)
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(String(format: "Average Vote: %.1f/10", movie.vote_average))
                    .font(.subheadline)
                    .foregroundColor(.black)
                Text("Release Date: \(movie.release_date)")
                    .font(.caption)
                    .foregroundColor(.black)
            }
            .padding()
            .cornerRadius(10)
            .foregroundColor(.black)
        }
    }
}

struct URLImage: View {
    @ObservedObject var imageLoader: ImageLoader
    let placeholder: Image
    
    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        imageLoader = ImageLoader(url: url)
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let uiImage = imageLoader.image {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
        } else {
            placeholder
                .resizable()
                .scaledToFit()
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieViewModel())
    }
}