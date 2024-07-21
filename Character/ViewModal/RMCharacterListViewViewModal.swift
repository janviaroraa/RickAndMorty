//
//  RMCharacterListViewViewModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import UIKit

protocol RMCharacterListViewViewModalProtocol: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(newResults: [RMCharacter])
    func didSelectCharacter(_ character: RMCharacter)
}

final class RMCharacterListViewViewModal: NSObject {

    weak var delegate: RMCharacterListViewViewModalProtocol?

    private(set) var characters = [RMCharacter]() {
        didSet {
            cellViewModel = []
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name ?? "Dedault name",
                    characterStatus: character.status ?? .unknown,
                    characterImageURL: URL(string: character.image ?? "")
                )
                cellViewModel.append(viewModel)
            }
        }
    }

    private var cellViewModel = [RMCharacterCollectionViewCellViewModel]()
    private var apiInfo: RMGetAllCharactersResponseModal.Info? = nil
    private var shouldLoadMoreCharacters = false

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    /// Fetches initial 20 characters
    func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharactersResponseModal.self) { [weak self] result in
            switch result {
            case .success(let model):
                guard let results = model.results,
                      let info = model.info else { return }
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                DispatchQueue.main.sync {
                    RMErrorToast(withText: error.localizedDescription).show()
                }
            }
        }
    }

    /// Fetches next 20 characters in line
    func fetchAdditionalCharacters(url: URL) {
        guard !shouldLoadMoreCharacters else { return }
        shouldLoadMoreCharacters = true

        guard let request = RMRequest(url: url) else {
            shouldLoadMoreCharacters = false
            print("Failed to create request")
            return
        }

        RMService.shared.execute(request, expecting: RMGetAllCharactersResponseModal.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                guard let moreResults = model.results,
                      let info = model.info else { return }
                self.apiInfo = info
                self.delegate?.didLoadMoreCharacters(newResults: moreResults)
                self.shouldLoadMoreCharacters = false
            case .failure(let error):
                self.shouldLoadMoreCharacters = false
                DispatchQueue.main.sync {
                    RMErrorToast(withText: error.localizedDescription).show()
                }
            }
        }
    }

    func appendCharacters(newResults: [RMCharacter]) {
        characters.append(contentsOf: newResults)
    }
}

extension RMCharacterListViewViewModal: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell!")
        }
        cell.configure(with: cellViewModel[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Unsupported")
        }

        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath
        ) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }

        footer.startAnimating()
        return footer
    }
}

extension RMCharacterListViewViewModal: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

extension RMCharacterListViewViewModal: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else { return .zero }
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

extension RMCharacterListViewViewModal: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !shouldLoadMoreCharacters,
              !cellViewModel.isEmpty,
              let urlString = apiInfo?.next,
              let url = URL(string: urlString) else { return }

        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height // Greater

            // Smaller - iPhone's frame
            // Gonna be fixed always
            // Will only gets changed if navigation item shrinks
            let totalFrameHeight = scrollView.frame.size.height

            // checking if we have reached at the end of scroll view
            // subracting 50 because of footer's height
            // subracting 20 as a buffer
            if offset >= (totalContentHeight - totalFrameHeight - 50 - 20) {
                self?.fetchAdditionalCharacters(url: url)
            }

            timer.invalidate()
        }
    }
}
