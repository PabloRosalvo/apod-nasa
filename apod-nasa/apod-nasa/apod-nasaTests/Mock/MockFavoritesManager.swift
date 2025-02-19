//
//  MockFavoritesManager.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 19/02/25.
//
import Foundation

@testable import apod_nasa

final class MockFavoritesManager: FavoritesManagerProtocol {
    var mockFavorites: [APODResponse] = []

    func toggleFavorite(_ apod: APODResponse) {
        if let index = mockFavorites.firstIndex(where: { $0.title == apod.title }) {
            mockFavorites.remove(at: index)
        } else {
            mockFavorites.append(apod)
        }
    }

    func saveFavorite(_ apod: APODResponse) {
        guard !mockFavorites.contains(where: { $0.title == apod.title }) else { return }
        mockFavorites.append(apod)
    }

    func removeFavorite(_ apod: APODResponse) {
        mockFavorites.removeAll { $0.title == apod.title }
    }

    func isFavorite(_ apod: APODResponse) -> Bool {
        return mockFavorites.contains(where: { $0.title == apod.title })
    }

    func getFavorites() -> [APODResponse] {
        return mockFavorites
    }
}
