//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import UIKit

enum RMLocationDetailSectionType {
    case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
    case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
}

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {

    private let endpointURL: URL?
    private(set) var cellViewModels: [RMLocationDetailSectionType] = []
    weak var delegate: RMLocationDetailViewViewModelDelegate?

    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }

    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }

    func character(at index: Int) -> RMCharacter? {
        guard let dataTuple else { return nil }
        return dataTuple.characters[index]
    }

    func fetchLocationData() {
        guard let endpointURL,
              let request = RMRequest(url: endpointURL) else { return }

        RMService.shared.execute(request, expecting: RMLocation.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func fetchRelatedCharacters(location: RMLocation) {
        let characetrURLs: [URL] = location.residents?.compactMap({
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
            self.dataTuple = (location, characters)
        }
    }

    private func createCellViewModels() {
        guard let dataTuple else { return }

        let location = dataTuple.location
        let characters = dataTuple.characters

        var createdString = location.created
        if let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created ?? "") {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: createdDate)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name ?? "N/A"),
                .init(title: "Type", value: location.type ?? "N/A"),
                .init(title: "Dimension", value: location.dimension ?? "N/A"),
                .init(title: "Creation Date", value: createdString ?? "N/A"),
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
