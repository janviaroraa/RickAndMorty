//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 15/07/24.
//

import UIKit

// Note: We can't use CaseIterable with associated enum types
enum RMCharacterDetailSectionType {
    case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
    case information(viewModels: [RMCharacterInfoCollectionViewCellViewModel])
    case episodes(viewModels: [RMCharacterEpisodesCollectionViewCellViewModel])
}

final class RMCharacterDetailViewViewModel {

    private let character: RMCharacter
    var sections: [RMCharacterDetailSectionType] = []

    var characterName: String {
        character.name?.uppercased() ?? "Default Name"
    }

    private var characterURL: URL? {
        guard let url = character.url else { return nil }
        return URL(string: url)
    }

    init(character: RMCharacter) {
        self.character = character
        setupSections()
    }

    private func setupSections() {
        sections = [
            .photo(viewModel: .init(imageURL: URL(string: character.image ?? ""))),
            .information(viewModels: [
                .init(type: .status, value: character.status?.text),
                .init(type: .species, value: character.species),
                .init(type: .type, value: character.type),
                .init(type: .gender, value: character.gender?.rawValue),
                .init(type: .origin, value: character.origin?.name),
                .init(type: .location, value: character.location?.name),
                .init(type: .episodeCount, value: String(character.episode?.count ?? 0)),
                .init(type: .created, value: character.created)
            ]),
            .episodes(viewModels: character.episode?.compactMap({
                return RMCharacterEpisodesCollectionViewCellViewModel(episodeDataURL: URL(string: $0))
            }) ?? [])
        ]
    }

}

// MARK: - Layouts

extension RMCharacterDetailViewViewModel {
    /*
     -  Options for Width/Height in NSCollectionLayoutSize:

        [a] .fractionalWidth(_ fractionalWidth: CGFloat) -> Self
            To specify a percentile based on the width of it's container
            (container here, the group in which item goes into)

        [b] .fractionalHeight(_ fractionalHeight: CGFloat) -> Self
            To specify a percentile based on the height of it's container
            (container here, the group in which item goes into)

        [c] .absolute(_ absoluteDimension: CGFloat) -> Self
            To give a fixed value for width or height

        [d] .estimated(_ estimatedDimension: CGFloat) -> Self
     */
    func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let layoutSizeForItem = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSizeForItem)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)

        let layoutSizeForGroup = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.6)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: layoutSizeForGroup,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func createInfoSectionLayout() -> NSCollectionLayoutSection {
        let layoutSizeForItem = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSizeForItem)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let layoutSizeForGroup = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSizeForGroup,
            subitems: [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        let layoutSizeForItem = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: layoutSizeForItem)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4)

        let layoutSizeForGroup = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .absolute(120)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: layoutSizeForGroup,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
