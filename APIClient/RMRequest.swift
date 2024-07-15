//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 13/07/24.
//

import Foundation

final class RMRequest {
    
    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }

    private let endpoint: RMEndPoint
    private let pathComponents: [String]
    private let queryParameters: [URLQueryItem]

    /// Constructed URL for the API request in string format
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue

        if !pathComponents.isEmpty {
            string += "/"
            pathComponents.forEach {(
                string += "\($0)"
            )}
        }

        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap ({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }

        return string
    }

    public var url: URL? {
        return URL(string: urlString)
    }

    public let httpMethod = "GET"

    public init(endpoint: RMEndPoint, 
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endpoint: .character)
    static let listLocationRequest = RMRequest(endpoint: .location)
    static let listEpisodesRequest = RMRequest(endpoint: .episode)
}
