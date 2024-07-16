//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 15/07/24.
//

import Foundation

final class RMCharacterDetailViewViewModel {

    private let character: RMCharacter

    var characterName: String {
        character.name?.uppercased() ?? "Default Name"
    }

    init(character: RMCharacter) {
        self.character = character
    }

}
