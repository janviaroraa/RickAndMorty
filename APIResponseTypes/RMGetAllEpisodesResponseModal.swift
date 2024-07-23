//
//  RMGetAllEpisodesResponseModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 22/07/24.
//

import Foundation

struct RMGetAllEpisodesResponseModal: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [RMEpisode]
}
