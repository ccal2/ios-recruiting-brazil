//
//  GenreRepository.swift
//  Movs
//
//  Created by c.cruz.agra.lopes on 03/03/20.
//  Copyright © 2020 Carolina Lopes. All rights reserved.
//

import Foundation

struct GenreRepository {

    // MARK: - Variables

    private let dataSource: APIDataFetcher  // TODO: protocol (?)

    // MARK: - Initializers

    init(dataSource: APIDataFetcher = APIDataFetcher()) {
        self.dataSource = dataSource
    }

    // MARK: - Fetch

    func fetchAll(completion: @escaping (Result<[Int: Genre], Error>) -> Void) {
        self.dataSource.performRequest(APIRequest.genres) { (result: Result<GenreWrapperDTO, Error>) in
            switch result {
            case let .success(genreWrapper):
                var genres: [Int: Genre] = [:]
                for genreDTO in genreWrapper.genres {
                    genres[genreDTO.id] = Genre(fromDTO: genreDTO)
                }
                completion(.success(genres))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
