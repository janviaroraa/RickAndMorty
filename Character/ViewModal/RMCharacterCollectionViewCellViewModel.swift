//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
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
        RMImageManager.shared.downloadImage(characterImageURL, completion: completion)
    }

    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
}
