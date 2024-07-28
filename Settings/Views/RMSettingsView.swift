//
//  RMSettingsView.swift
//  RickAndMorty
//
//  Created by Janvi Arora on 27/07/24.
//

import SwiftUI

struct RMSettingsView: View {

    let viewModel: RMSettingsViewViewModal

    init(viewModel: RMSettingsViewViewModal) {
        self.viewModel = viewModel
    }

    var body: some View {
        List(viewModel.cellViewModels) { cellViewModel in
            HStack {
                if let image = cellViewModel.image {
                    Image(uiImage: image)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                        .padding(8)
                        .background(Color(uiColor: cellViewModel.tintColor))
                        .cornerRadius(8)
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 10))
                }
                Text(cellViewModel.title)
                    .font(.headline)
            }.onTapGesture {
                cellViewModel.onTapHandler(cellViewModel.type)
            }
        }
    }
}

#Preview {
    RMSettingsView(viewModel: RMSettingsViewViewModal(cellViewModels: RMSettingsOptions.allCases.compactMap({
        return RMSettingsCellViewViewModal(type: $0) { option in
            
        }
    })))
}
