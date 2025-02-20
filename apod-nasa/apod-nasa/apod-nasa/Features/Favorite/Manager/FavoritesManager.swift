import Foundation
import Combine

protocol FavoritesManagerProtocol {
    func toggleFavorite(_ apod: APODResponse)
    func saveFavorite(_ apod: APODResponse)
    func removeFavorite(_ apod: APODResponse)
    func isFavorite(_ apod: APODResponse) -> Bool
    func getFavorites() -> [APODResponse]
    var favoritesPublisher: Published<[APODResponse]>.Publisher { get }
}

final class FavoritesManager: FavoritesManagerProtocol {
    
    static let shared = FavoritesManager()
    private let key = "favorite_apods"

    @Published private var favoritesCache: [APODResponse] = []

    private init() {
        loadFavoritesFromStorage()
    }
    
    var favoritesPublisher: Published<[APODResponse]>.Publisher { $favoritesCache }
    
    func toggleFavorite(_ apod: APODResponse) {
        if isFavorite(apod) {
            removeFavorite(apod)
        } else {
            saveFavorite(apod)
        }
    }
    
    func saveFavorite(_ apod: APODResponse) {
        guard !isFavorite(apod) else { return }
        favoritesCache.append(apod)
        updateStorage()
    }
    
    func removeFavorite(_ apod: APODResponse) {
        favoritesCache.removeAll { $0.title == apod.title }
        updateStorage()
    }
    
    func isFavorite(_ apod: APODResponse) -> Bool {
        return favoritesCache.contains { $0.title == apod.title }
    }
    
    func getFavorites() -> [APODResponse] {
        return favoritesCache
    }
    
    private func loadFavoritesFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let favorites = try? JSONDecoder().decode([APODResponse].self, from: data) else {
            return
        }
        favoritesCache = favorites
    }
    
    private func updateStorage() {
        if let data = try? JSONEncoder().encode(favoritesCache) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
