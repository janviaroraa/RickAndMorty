//
//  RMSearchViewViewModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import Foundation

/*
 Responsibilities (all heavy-lifting):
 - Get search results
 - Kick off logic for no results view
 - Kick off API requests
 */

final class RMSearchViewViewModal {

    let config: RMSearchConfig
    private var searchText: String = ""
    private var optionsDict = [RMSearchDynamicOption: String]()
    private var optionMapUpdateBlock: (((RMSearchDynamicOption, String)) -> Void)?
    private var searchResultHandler: ((RMSearchResultsRepresentable) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var searchResultsModal: Codable?

    init(config: RMSearchConfig) {
        self.config = config
    }

    func executeSearch() {
        // Step 1: Create request based on filters and entered query
        var queryParams = [URLQueryItem]()

        if !searchText.isEmpty {
            let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            queryParams.append(URLQueryItem(name: "name", value: escapedSearchText))
        }

        queryParams.append(contentsOf: optionsDict.enumerated().compactMap({ (index, element) in
            let key: RMSearchDynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArguments, value: value)
        }))

        // Step 2: Make API call
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )

        switch config.type.endpoint {
        case .character:
            makeAPICall(RMGetAllCharactersResponseModal.self, request: request)
        case .location: 
            makeAPICall(RMGetAllLocationsResponseModal.self, request: request)
        case .episode: 
            makeAPICall(RMGetAllEpisodesResponseModal.self, request: request)
        }

        // Step 3: Notify view of results, no results or error
    }

    private func makeAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let modal):
                self?.processSearchResults(modal: modal)
            case .failure(let error):
                self?.handleNoResults()
                break
            }
        }
    }

    private func processSearchResults(modal: Codable) {
        var results: RMSearchResultsRepresentable?

        if let characterModal = modal as? RMGetAllCharactersResponseModal {
            results = .characters(characterModal.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name ?? "N/A",
                    characterStatus: $0.status ?? .unknown,
                    characterImageURL: URL(string: $0.image ?? "")
                )
            }))
        } else if let locationModal = modal as? RMGetAllLocationsResponseModal {
            results = .locations(locationModal.results.compactMap({
                return RMLocationTableViewCellViewModal(location: $0)
            }))
        } else if let episodeModal = modal as? RMGetAllEpisodesResponseModal {
            results = .episodes(episodeModal.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url ?? ""))
            }))
        }

        if let results = results {
            searchResultsModal = modal
            searchResultHandler?(results)
        } else {
            handleNoResults()
        }
    }

    func registerSearchResultHandler(_ block: @escaping ((RMSearchResultsRepresentable) -> Void)) {
        searchResultHandler = block
    }

    func noSearchResultsHandler(_ block: @escaping (() -> Void)) {
        noResultsHandler = block
    }

    func handleNoResults() {
        noResultsHandler?()
    }

    func set(option: RMSearchDynamicOption, value: String) {
        optionsDict[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    func set(query text: String) {
        searchText = text
    }

    func registerOptionChangeblock(
        _ block: @escaping (((RMSearchDynamicOption, String)) -> Void)
    ) {
        self.optionMapUpdateBlock = block
    }

    func locationsSearchResult(at index: Int) -> RMLocation? {
        guard let searchedResults = searchResultsModal as? RMGetAllLocationsResponseModal else { return nil }
        return searchedResults.results[index]
    }
}
