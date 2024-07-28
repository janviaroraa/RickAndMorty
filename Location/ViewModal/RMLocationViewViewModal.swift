//
//  RMLocationViewViewModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 28/07/24.
//

import Foundation

protocol RMLocationViewViewModalDelegate: AnyObject {
    func didFetchInitialLocations()
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
    private var apiInfo: RMGetAllLocationsResponseModal.Info?

    private var hasMoreResults: Bool {
        return false
    }

    init() {

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

}
