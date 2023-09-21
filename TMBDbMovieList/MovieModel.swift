//
//  MovieModel.swift
//  TMBDbMovieList
//
//  Created by Auto on 9/16/23.
//

import Foundation

struct Movie: Identifiable, Decodable {
    let id: Int
    let popularity: Double
    let title: String
    let backdrop_path: String?
    let poster_path: String?
    let vote_average: Double
    let vote_count: Int
    let runtime: Int?
}
