//
//  RMLocationTableViewCellViewModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import Foundation

final class RMLocationTableViewCellViewModal: Hashable, Equatable {
    
    private let location: RMLocation

    var name: String {
        return location.name ?? "N/A"
    }

    var type: String {
        return location.type ?? "N/A"
    }

    var dimension: String {
        return location.dimension ?? "N/A"
    }

    init(location: RMLocation) {
        self.location = location
    }

    static func == (lhs: RMLocationTableViewCellViewModal, rhs: RMLocationTableViewCellViewModal) -> Bool {
        return lhs.location.id == rhs.location.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(dimension)
        hasher.combine(location.id)
    }
}
