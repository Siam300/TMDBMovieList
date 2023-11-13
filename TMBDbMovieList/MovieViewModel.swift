//
//  MovieViewModel.swift
//  TMBDbMovieList
//
//  Created by Auto on 9/16/23.
//

import SwiftUI
import Foundation
import UIKit
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    
    init(url: URL) {
        self.loadImage(from: url)
    }
    
    public func loadImage(from url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}

class MovieViewModel: ObservableObject {
    
    @Published var movies: [Movie] = []
    @Published var isError = false
    @Published var page: Int = 1
    @Published private(set) var isLoading = false
    
    init() {
        getData()
    }

    func setIsLoading(_ value: Bool) {
            isLoading = value
        }
    
    func getData() {
        guard !isLoading else {
            return
        }
        
        isLoading = true

        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=\(page)&sort_by=vote_average.desc&without_genres=99,10755&vote_count.gte=200&api_key=840e2c16b07096959518023fa50e8253") else {
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    print("Network error: \(error)")
                    self?.isError = true
                } else if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(MovieResponse.self, from: data)
                        self?.movies.append(contentsOf: decodedData.results)
                        self?.page += 1
                    } catch let error {
                        print("JSON parsing error: \(error)")
                        self?.isError = true
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func loadMoreData() {
        getData()
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}
