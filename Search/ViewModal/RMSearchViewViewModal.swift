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
    private var searchText: String? = nil
    private var optionsDict = [RMSearchDynamicOption: String]()
    private var optionMapUpdateBlock: (((RMSearchDynamicOption, String)) -> Void)?

    init(config: RMSearchConfig) {
        self.config = config
    }

    func executeSearch() {
        // Step 1: Create request based on filters or entered query
        // Step 2: Send API call
        // Step 3: Notify view of results, no results or error
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
}
