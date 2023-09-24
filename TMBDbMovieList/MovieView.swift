//
//  MovieList.swift
//  TMBDbMovieList
//
//  Created by Auto on 8/18/23.
//

import SwiftUI

struct URLImage: View {
    let urlString: String
    @State private var data: Data? = nil
    
    var body: some View {
        if let data = data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .onAppear {
                    if let url = URL(string: urlString) {
                        URLSession.shared.dataTask(with: url) { data, _, _ in
                            if let data = data {
                                DispatchQueue.main.async {
                                    self.data = data
                                }
                            }
                        }.resume()
                    }
                }
        }
    }
}

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                VStack(alignment: .leading) {
                    if let localImage = viewModel.getLocalImage(for: movie.poster_path) {
                        Image(uiImage: UIImage(contentsOfFile: localImage.path)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 300)
                    }
                    if let localBackdrop = viewModel.getLocalImage(for: movie.backdrop_path) {
                        Image(uiImage: UIImage(contentsOfFile: localBackdrop.path)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 100)
                    }
                    Text(movie.title)
                        .font(.headline)
                    Text("Popularity: \(movie.popularity)")
                        .font(.subheadline)
                    Text("Average Vote: \(movie.vote_average)")
                        .font(.subheadline)
                    Text("Vote Count: \(movie.vote_count)")
                        .font(.subheadline)
                }
            }
        }
        .navigationBarTitle("Top Movies")
        .onAppear {
            viewModel.getData()
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieViewModel())
    }
}


