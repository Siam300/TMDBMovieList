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
                        Button(action: {
                            selectedMovie = movie
                        }) {
                            HStack {
                                if let posterPath = movie.poster_path,
                                   let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                                    URLImage(url: url)
                                        .frame(width: 150, height: 200)
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 200)
                                }
                                LazyVStack(alignment: .leading) {
                                    TextView(index: index, movie: movie)
                                }
                                .padding()
                                .cornerRadius(10)
                                .foregroundColor(.black)
                            }
                            //.background(Color("primary"))
                            .edgesIgnoringSafeArea(.all)
                        }
                    }
                    .listRowBackground(Color("primary"))
                }
                .padding(0)
                .navigationBarTitle("Top 20 Movies")
                .sheet(item: $selectedMovie) { movie in
                    MovieDetailsView(viewModel: viewModel, movie: movie)
                }
            }
        }
        .listStyle(PlainListStyle())
        //.background(Color("primary"))
    }
    
    func TextView(index: Int, movie: Movie) -> some View {
        VStack(alignment: .leading) {
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

struct MovieDetailsView: View {
    @ObservedObject var viewModel: MovieViewModel
    let movie: Movie
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color("secondary")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
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
                    Spacer()
                    if let posterPath = movie.poster_path,
                       let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                        URLImage(url: url)
                            .scaledToFit()
                            .frame(width: 120, height: 200)
                    }
                }
                Spacer()
                ScrollView{
                    Text("Overview: \(movie.overview)")
                        .font(.headline)
                    if let backdropPath = movie.backdrop_path,
                       let url = URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)") {
                        URLImage(url: url)
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.top, 10)
                        
                    } else {
                        Image(systemName: "photo")
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding(.top, 10)
                    }
                }
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.square.fill")
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                })
            }
            //.background(Color.clear)
            .foregroundColor(.black)
            .cornerRadius(15)
            .frame(maxWidth: .infinity)
            //            .overlay(
            //                RoundedRectangle(cornerRadius: 10)
            //                    .stroke(Color.black, lineWidth: 2)
            //            )
            .padding(20)
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieViewModel())
    }
}
