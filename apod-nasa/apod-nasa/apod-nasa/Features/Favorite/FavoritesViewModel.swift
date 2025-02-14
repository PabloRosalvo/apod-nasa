//
//  ViewModel.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//

import Foundation
import Combine

struct FavoritesListModel {
    let title: String
    let mediaURL: String?
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    var favoritesPublisher: AnyPublisher<[FavoritesListModel], Never> {
        $favorites.eraseToAnyPublisher()
    }
        
    @Published private var favorites: [FavoritesListModel] = []
 
    func getFavorites() -> [FavoritesListModel] {
        return favorites
    }
    
    func loadFavorites() {
        let favoriteAPODs = FavoritesManager.shared.getFavorites()
        favorites = favoriteAPODs.map { FavoritesListModel(title: $0.title, mediaURL: $0.url) }
    }
    
    func removeFavorite(at index: Int) {
        let favoriteToRemove = FavoritesManager.shared.getFavorites()[index]
        FavoritesManager.shared.removeFavorite(favoriteToRemove)
        loadFavorites()
    }
}
