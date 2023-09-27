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
    
    private func loadImage(from url: URL) {
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
    
    func getLocalImage(for imagePath: String?, completion: @escaping (URL?) -> Void) {
        guard let imagePath = imagePath else {
            completion(nil)
            return
        }

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localImageUrl = documentsDirectory.appendingPathComponent(imagePath)

        if FileManager.default.fileExists(atPath: localImageUrl.path) {
            completion(localImageUrl)
        } else {
            let remoteImageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")!
            let task = URLSession.shared.dataTask(with: remoteImageUrl) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error downloading image data: \(error ?? NSError())")
                    completion(nil)
                    return
                }
                do {
                    try data.write(to: localImageUrl)
                    completion(localImageUrl)
                } catch {
                    print("Error saving image data: \(error)")
                    completion(nil)
                }
            }
            task.resume()
        }
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}
