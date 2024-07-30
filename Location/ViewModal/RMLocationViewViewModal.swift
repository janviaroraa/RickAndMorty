//
//  RMLocationViewViewModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import Foundation

protocol RMLocationViewViewModalDelegate: AnyObject {
    func didFetchInitialLocations()
    func didLoadMoreLocations(with newIndexPaths: [IndexPath])
}

final class RMLocationViewViewModal {

    private var locations = [RMLocation]() {
        didSet {
            for location in locations {
                let cellViewModal = RMLocationTableViewCellViewModal(location: location)
                if !cellViewModals.contains(cellViewModal) {
                    cellViewModals.append(cellViewModal)
                }
            }
        }
    }

    var cellViewModals = [RMLocationTableViewCellViewModal]()

    weak var delegate: RMLocationViewViewModalDelegate?
    var apiInfo: RMGetAllLocationsResponseModal.Info?
    var isLoadingMoreLocations = false

    private var hasMoreResults: Bool {
        return false
    }

    init() {

    }

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    func location(at index: Int) -> RMLocation? {
        guard index < locations.count else { return nil }
        return locations[index]
    }

    func fetchLocations() {
        RMService.shared.execute(.listLocationRequest, expecting: RMGetAllLocationsResponseModal.self) { [weak self] result in
            switch result {
            case .success(let modal):
                self?.apiInfo = modal.info
                self?.locations = modal.results
                self?.delegate?.didFetchInitialLocations()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchAdditionalLocations(url: URL) {
        guard !isLoadingMoreLocations else {
            return
        }
        isLoadingMoreLocations = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }

        RMService.shared.execute(request, expecting: RMGetAllLocationsResponseModal.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info

                let originalCount = strongSelf.locations.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.locations.append(contentsOf: moreResults)

                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreLocations(with: indexPathsToAdd)

                    strongSelf.isLoadingMoreLocations = false
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreLocations = false
            }
        }
    }

}
