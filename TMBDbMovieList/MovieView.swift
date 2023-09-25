//
//  MovieList.swift
//  TMBDbMovieList
//
//  Created by Auto on 8/18/23.
//

import SwiftUI

struct URLImage: View {
    let urlString: String
    @State var data: Data?
    
    var body: some View {
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 70)
        }
    }
}

struct MovieListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @State private var selectedMovie: Movie?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.movies.indices, id: \.self) { index in
                    let movie = viewModel.movies[index]
                    Button(action: {
                        selectedMovie = movie
                    }) {
                        HStack {
                            if let localImage = viewModel.getLocalImage(for: movie.poster_path) {
                                Image(uiImage: UIImage(contentsOfFile: localImage.path)!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 200)
                            }
                            LazyVStack(alignment: .leading) {
                                Text("Ranking: \(index + 1).")
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding(.trailing, 5)
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .foregroundColor(.white)
                        }
                    }
                }
            }
            .navigationBarTitle("Top Movies")
            .onAppear {
                viewModel.getData()
            }
            .sheet(item: $selectedMovie) { movie in
                MovieDetailsView(movie: movie)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.black)
    }
}


struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieViewModel())
    }
}

struct MovieDetailsView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Title: \(movie.title)")
                .font(.headline)
            Text("Language: \(movie.original_language)")
                .font(.subheadline)
            Text(String(format: "Rating: %.1f/10", movie.vote_average))
                .font(.subheadline)
            Text("Vote Count: \(movie.vote_count)")
                .font(.subheadline)
            Text(String(format: "Poluparity: %.3f", movie.popularity))
                .font(.subheadline)
            Text("Release Date: \(movie.release_date)")
                .font(.subheadline)
            Text("Overview: \(movie.overview)")
                .font(.subheadline)
            if let backdropPath = movie.backdrop_path {
                Image(uiImage: getImage(from: backdropPath))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding(.top, 10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(10)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 2)
        )
        .padding(20)
    }
    
    func getImage(from urlString: String) -> UIImage {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(urlString)"),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data)
        else {
            return UIImage()
        }
        return image
    }
}
