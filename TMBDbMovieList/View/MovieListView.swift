//
//  MovieList.swift
//  TMBDbMovieList
//
//  Created by Auto on 8/18/23.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Binding var movies: [Movie]
    
    var body: some View {
            ZStack {
                Color("primary")
                    .edgesIgnoringSafeArea(.all)
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.movies.indices, id: \.self) { index in
                            let movie = viewModel.movies[index]
                            NavigationLink(destination: MovieDetailsView(viewModel: viewModel, movie: movie)) {
                                MovieView(movie: movie, index: index)
                            }
                            .onAppear {
                                viewModel.loadMoreData()
                            }
                            .transition(.opacity) 
                            Rectangle()
                                .fill()
                                .foregroundColor(Color.gray)
                                .frame(height: 0.5)
                        }
                    }
                    .background(Color("primary"))
                    .foregroundColor(.black)
                }
                .padding(.horizontal, 15)
            }
    }
    
    func MovieView(movie: Movie, index: Int) -> some View {
        let URLString = "https://image.tmdb.org/t/p/w500"
        return HStack {
            if let posterPath = movie.poster_path,
               let posterURL = URL(string: URLString + posterPath) {
                URLImage(url: posterURL)
                    .frame(width: 140, height: 200)
            }
            else {
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
                    .multilineTextAlignment(.leading)

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
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            @unknown default:
                EmptyView()
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieViewModel(), movies: .constant([]))
    }
}
