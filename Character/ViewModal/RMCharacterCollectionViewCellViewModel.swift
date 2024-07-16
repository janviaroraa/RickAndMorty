//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel {

    var characterName: String
    private var characterStatus: RMCharacterStatus
    private var characterImageURL: URL?

    var charcterStatusText: String {
        "Status: \(characterStatus.text)"
    }

    init(characterName: String, characterStatus: RMCharacterStatus, characterImageURL: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let characterImageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let urlRequest = URLRequest(url: characterImageURL)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data, error == nil else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            completion(.success(data))
        }.resume()
    }
}
