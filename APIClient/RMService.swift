//
//  RMService.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import Foundation

final class RMService {

    static let shared = RMService()

    private let cacheManager = RMAPICacheManager()

    private init() { }

    func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, RMServiceError>
    ) -> Void) {
        if let cacheData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cacheData)
                completion(.success(result))
            } catch {
                completion(.failure(.failedToGetData))
            }
            return
        }

        guard let urlRequest = self.request(from: request) else {
            completion(.failure(.failedToCreateRequest))
            return
        }

        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data, error == nil else {
                completion(.failure(.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCacheResponse(for: request.endpoint, url: request.url, data: data)
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
