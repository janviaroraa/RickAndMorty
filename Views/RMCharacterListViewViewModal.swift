//
//  RMCharacterListViewViewModal.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 14/07/24.
//

import UIKit

final class RMCharacterListViewViewModal: NSObject {

    func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharactersResponseModal.self) { result in
            switch result {
            case .success(let char):
                print(char)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

extension RMCharacterListViewViewModal: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.identifier, for: indexPath) as? RMCharacterCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundColor = .gray
        return cell
    }
}

extension RMCharacterListViewViewModal: UICollectionViewDelegate {

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
}
