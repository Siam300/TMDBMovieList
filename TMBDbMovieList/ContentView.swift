//
//  ContentView.swift
//  TMBDbMovieList
//
//  Created by Auto on 11/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var movieViewModel = MovieViewModel()

    var body: some View {
        CustomNavigationView(
            view: MovieListView(viewModel: movieViewModel),
            onSearch: { (txt) in
                print("from SwiftUI")
            },
            onCancel: {
                print("From Cancel")
            }
        )
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
