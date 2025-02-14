//
//  MockFavoritesViewModel.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 14/02/25.
//
import Combine
import Foundation

@testable import apod_nasa

final class MockFavoritesViewModel: FavoritesViewModelProtocol {
    var favoritesSubject = CurrentValueSubject<[FavoritesListModel], Never>([])

    var favoritesPublisher: AnyPublisher<[FavoritesListModel], Never> {
        favoritesSubject.eraseToAnyPublisher()
    }

    func loadFavorites() {
        let mockFavorites = [
            FavoritesListModel(title: "Galáxia de Andrômeda", mediaURL: "image_teste"),
            FavoritesListModel(title: "Nebulosa de Órion", mediaURL: "image_teste")
        ]
        favoritesSubject.send(mockFavorites)
    }

    func getFavorites() -> [FavoritesListModel] {
        return favoritesSubject.value
    }

    func removeFavorite(at index: Int) {
        var currentFavorites = favoritesSubject.value
        guard index < currentFavorites.count else { return }
        currentFavorites.remove(at: index)
        favoritesSubject.send(currentFavorites)
    }
}

