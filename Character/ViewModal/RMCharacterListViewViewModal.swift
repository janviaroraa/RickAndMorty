//
//  RMCharacterListViewViewModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import UIKit

protocol RMCharacterListViewViewModalProtocol: AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: RMCharacter)
}

final class RMCharacterListViewViewModal: NSObject {

    weak var delegate: RMCharacterListViewViewModalProtocol?

    private var characters = [RMCharacter]() {
        didSet {
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

    var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    /// Fetches initial 20 characters
    func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharactersResponseModal.self) { [weak self] result in
            switch result {
            case .success(let model):
                guard let results = model.results, let info = model.info else { return }
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }

    /// Fetches next 20 characters in line
    func fetchAdditionalCharacters() {
        
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

        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            return UICollectionReusableView()
        }

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
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

extension RMCharacterListViewViewModal: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator else { return }

    }
}
