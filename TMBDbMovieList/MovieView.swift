//
//  MovieList.swift
//  TMBDbMovieList
//
//  Created by Auto on 8/18/23.
//

import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in 
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.headline)
                    Text("Popularity: \(movie.popularity)")
                        .font(.subheadline)
//                    Text("Average Vote: \(movie.voteAverage)")
//                        .font(.subheadline)
                }
            }
            .navigationBarTitle("Top Movies")
            .onAppear {
                viewModel.getData()
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieViewModel())
    }
}


