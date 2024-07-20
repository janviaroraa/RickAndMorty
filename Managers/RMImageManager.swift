//
//  RMImageManager.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 19/07/24.
//

import Foundation

final class RMImageManager {
    static let shared = RMImageManager()

    // NSCache: Obj-C Concept
    // Note: We can also perform read-write operations in disk, but I'll be a really heavy operation, & will consume lots of resources and system memory.
    private var imageCache = NSCache<NSString, NSData>()

    private init() { }

    func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }

        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let data, error == nil else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            let value = data as NSData
            self? .imageCache.setObject(value, forKey: key)

            completion(.success(data))
        }.resume()
    }
}
