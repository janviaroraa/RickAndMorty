//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 20/07/24.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {

    private let imageURL: URL?

    init(imageURL: URL?) {
        self.imageURL = imageURL
    }

    // Since we'll have the image in the memory because we'll click the image at the home screen of character tab and then navigate to character detail screen, it'll always fetch image from the cache directly, and won't ever have to download it again, in this case.
    func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageManager.shared.downloadImage(imageURL, completion: completion)
    }
}
