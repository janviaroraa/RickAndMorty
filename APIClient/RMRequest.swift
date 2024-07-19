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

    convenience init?(url: URL) {
        let urlString = url.absoluteString
        if !urlString.contains(Constants.baseURL) {
            return nil
        }

        let trimmed = urlString.replacingOccurrences(of: Constants.baseURL+"/", with: "")

        // Example: BaseURL/character/
        // Example: BaseURL/character/
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                if let rmEndpoint = RMEndPoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")

                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })

                if let rmEndpoint = RMEndPoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endpoint: .character)
    static let listLocationRequest = RMRequest(endpoint: .location)
    static let listEpisodesRequest = RMRequest(endpoint: .episode)
}
