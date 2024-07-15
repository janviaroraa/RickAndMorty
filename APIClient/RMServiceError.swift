//
//  RMServiceError.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import Foundation

enum RMServiceError: Error {
    case failedToCreateRequest
    case failedToGetData
    case failedToDecodeData
}
