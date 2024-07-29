//
//  RMGetAllCharactersResponseModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import Foundation

struct RMGetAllCharactersResponseModal: Codable {

    struct Info: Codable {
        let count: Int?
        let pages: Int?
        let next: String?
        let prev: String?
    }

    let info: Info?
    let results: [RMCharacter]
}
