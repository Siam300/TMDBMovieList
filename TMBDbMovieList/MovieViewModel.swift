//
//  MovieViewModel.swift
//  TMBDbMovieList
//
//  Created by Auto on 9/16/23.
//

import SwiftUI
import Foundation

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isError = false
    
    init() {
        getData()
    }
    
    func getData() {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=vote_average.desc&without_genres=99,10755&vote_count.gte=200&api_key=840e2c16b07096959518023fa50e8253") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network error: \(error)")
                    self?.isError = true
                } else if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(MovieResponse.self, from: data)
                        self?.movies = decodedData.results
                    } catch let error {
                        print("JSON parsing error: \(error)")
                        self?.isError = true
                    }
                }
            }
        }
        dataTask.resume()
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}
