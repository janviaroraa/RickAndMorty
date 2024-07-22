//
//  RMCharacterEpisodesCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 20/07/24.
//

import Foundation

protocol RMEpisodeDataRender {
    var name: String? { get }
    var air_date: String? { get }
    var episode: String? { get }
}

final class RMCharacterEpisodesCollectionViewCellViewModel {

    private let episodeDataURL: URL?
    private var isFetching = false
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?

    private var episode: RMEpisode? {
        didSet {
            guard let episode else { return }
            dataBlock?(episode)
        }
    }

    init(episodeDataURL: URL?) {
        self.episodeDataURL = episodeDataURL
    }

    // PUBLISHSER & SUBSCRIBER PATTERN
    func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }

    func fetchEpisode() {
        guard !isFetching else {
            if let episode {
                dataBlock?(episode)
            }
            return
        }
        guard let episodeDataURL,
              let request = RMRequest(url: episodeDataURL) else { return }

        isFetching = true

        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let episode):
                self?.episode = episode
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

/*

 We have 2 options to fetch episodes:

 1. We can set a flag and mark it true if we have already fetched data for that particular episode or we are fetching.

 2. We can perform a background fetch so that by the time we get into the controller, our data is already ready.

 */
