//
//  APIRequest.swift
//  Movs
//
//  Created by c.cruz.agra.lopes on 03/03/20.
//  Copyright © 2020 Carolina Lopes. All rights reserved.
//

import Foundation

private let apiKey = "?api_key=cd452742413393c82b42c10e1c1cb8c7"
private let baseURL = "https://api.themoviedb.org/3"
private let imageBaseURL = "https://image.tmdb.org/t/p/"

enum APIRequest {
    case genres
    case popularMovies(page: Int)
    case movie(id: Int)
    case image(size: ImageSize, path: String)

    var url: String {
        switch self {
        case .genres:
            return baseURL + "/genre/movie/list" + apiKey
        case let .popularMovies(page):
            return baseURL + "/movie/popular" + apiKey + "&page=\(page)"
        case let .movie(id):
            return baseURL + "/movie/\(id)"  + apiKey
        case let .image(size, path):
            return imageBaseURL + size.rawValue + path
        }
    }
}

// MARK: - ImageSize

extension APIRequest {

    enum ImageSize: String {
        case small = "w342"
        case big = "w500"
    }
}
