//
//  FavoritesManager.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//
import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private let key = "favorite_apods"

    private init() {}

    func toggleFavorite(_ apod: APODResponse) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(where: { $0.title == apod.title }) {
            favorites.remove(at: index)
        } else {
            favorites.append(apod)
        }
        save(favorites)
    }

    func saveFavorite(_ apod: APODResponse) {
        var favorites = getFavorites()
        guard !favorites.contains(where: { $0.title == apod.title }) else { return }
        favorites.append(apod)
        save(favorites)
    }

    func removeFavorite(_ apod: APODResponse) {
        var favorites = getFavorites()
        favorites.removeAll { $0.title == apod.title }
        save(favorites)
    }

    func isFavorite(_ apod: APODResponse) -> Bool {
        return getFavorites().contains(where: { $0.title == apod.title })
    }

    func getFavorites() -> [APODResponse] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let favorites = try? JSONDecoder().decode([APODResponse].self, from: data) else {
            return []
        }
        return favorites
    }

    private func save(_ favorites: [APODResponse]) {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
