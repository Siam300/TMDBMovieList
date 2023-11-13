//
//  ContentView.swift
//  TMBDbMovieList
//
//  Created by Auto on 11/12/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var movieViewModel = MovieViewModel()
    @State var movies: [Movie] = []

    var body: some View {
        
        CustomNavigationView(
            view: AnyView(MovieListView(viewModel: movieViewModel, movies: $movies)),
            placeHolder: "Search Movies",
            largeTitle: true,
            title: "Top Rated Movies",
            onSearch: { (txt) in
                print("Search")
                if txt != "" {
                    self.movies = movies.filter { $0.title.lowercased().contains(txt.lowercased()) }
                } else {
                    self.movies = movieViewModel.movies
                }
            },
            onCancel: {
                self.movies = movieViewModel.movies
                print("Cancel")
            }
        )
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(movies: [])
    }
}
