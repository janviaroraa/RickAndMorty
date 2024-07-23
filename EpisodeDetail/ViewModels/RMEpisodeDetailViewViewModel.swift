//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 22/07/24.
//

import Foundation

final class RMEpisodeDetailViewViewModel {

    private let endpointURL: URL?

    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
        fetchEpisodeData()
    }

    private func fetchEpisodeData() {
        guard let endpointURL,
              let request = RMRequest(url: endpointURL) else { return }

        RMService.shared.execute(request, expecting: RMEpisode.self) { result in
            switch result {
            case .success(let model):
                print(model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
