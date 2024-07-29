//
//  RMSearchResultsRepresentable.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 29/07/24.
//

import Foundation

enum RMSearchResultsRepresentable {
    case characters([RMCharacterCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModal])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
}
