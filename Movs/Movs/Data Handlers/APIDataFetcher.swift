//
//  APIDataFetcher.swift
//  Movs
//
//  Created by c.cruz.agra.lopes on 03/03/20.
//  Copyright © 2020 Carolina Lopes. All rights reserved.
//

import Foundation

struct APIDataFetcher {

    // MARK: - Variables

    private let session: URLSession

    // MARK: - Initializers

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // MARK: - Request data

    func performRequest<DTOModel: Decodable>(_ request: APIRequest, completion: @escaping (Result<DTOModel, Error>) -> Void) {
        let dataTask = self.session.dataTask(with: URL(string: request.url)!) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let data = try JSONDecoder().decode(DTOModel.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
        }

        dataTask.resume()
    }
}
