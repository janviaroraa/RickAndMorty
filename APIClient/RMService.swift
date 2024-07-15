//
//  RMService.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import Foundation

final class RMService {

    static let shared = RMService()

    private init() { }

    func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, RMServiceError>
    ) -> Void) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(.failedToCreateRequest))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.failedToDecodeData))
            }
        }.resume()
    }

    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
