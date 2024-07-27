//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 22/07/24.
//

import UIKit

enum RMEpisodeDetailSectionType {
    case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
    case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
}

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {

    private let endpointURL: URL?
    private(set) var cellViewModels: [RMEpisodeDetailSectionType] = []
    weak var delegate: RMEpisodeDetailViewViewModelDelegate?

    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }

    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }

    func character(at index: Int) -> RMCharacter? {
        guard let dataTuple else { return nil }
        return dataTuple.characters[index]
    }

    func fetchEpisodeData() {
        guard let endpointURL,
              let request = RMRequest(url: endpointURL) else { return }

        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func fetchRelatedCharacters(episode: RMEpisode) {
        let characetrURLs: [URL] = episode.characters?.compactMap({
            return URL(string: $0)
        }) ?? []

        let requests: [RMRequest] = characetrURLs.compactMap({
            return RMRequest(url: $0)
        })

        // Making parallel requests & DispatchGroup will notify us when all the requests have been completed.
        let group = DispatchGroup()
        var characters: [RMCharacter] = []

        for request in requests {
            group.enter() // +20

            RMService.shared.execute(request, expecting: RMCharacter.self) { result in

                defer {
                    group.leave() // -20
                }

                switch result {
                case .success(let character):
                    characters.append(character)
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
            }
        }

        group.notify(queue: .main) {
            self.dataTuple = (episode, characters)
        }
    }

    private func createCellViewModels() {
        guard let dataTuple else { return }

        let episode = dataTuple.episode
        let characters = dataTuple.characters

        var createdString = episode.created
        if let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created ?? "") {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: createdDate)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name ?? "N/A"),
                .init(title: "Air Date", value: episode.air_date ?? "N/A"),
                .init(title: "Creation Date", value: createdString ?? "N/A"),
                .init(title: "Episode", value: episode.episode ?? "N/A"),
            ]),

            .characters(viewModels: characters.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name ?? "N/A",
                    characterStatus: $0.status ?? .unknown,
                    characterImageURL: URL(string: $0.image ?? "")
                )
            }))
        ]

    }
}
