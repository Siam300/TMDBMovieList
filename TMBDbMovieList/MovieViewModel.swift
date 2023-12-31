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
    @Published private(set) var isLoading = false
    private var cancellable: AnyCancellable?
    private var page = 1

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

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if case .failure(let error) = completion {
                        print("Network error: \(error)")
                        self.isError = true
                    }
                }
            }, receiveValue: { [weak self] decodedData in
                DispatchQueue.main.async {
                    self?.movies.append(contentsOf: decodedData.results)
                    self?.page += 1
                }
            })
    }

    func loadMoreData() {
        getData()
    }
}


struct MovieResponse: Decodable {
    let results: [Movie]
}
