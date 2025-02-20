import Foundation
import Combine

@testable import apod_nasa

final class MockFavoritesManager: FavoritesManagerProtocol {
    
    @Published var favoritesCache: [APODResponse] = []
    var favoritesPublisher: Published<[APODResponse]>.Publisher { $favoritesCache }
    
    init(initialFavorites: [APODResponse] = []) {
        self.favoritesCache = initialFavorites
    }

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
    }
    
    func removeFavorite(_ apod: APODResponse) {
        favoritesCache.removeAll { $0.title == apod.title }
    }
    
    func isFavorite(_ apod: APODResponse) -> Bool {
        return favoritesCache.contains { $0.title == apod.title }
    }
    
    func getFavorites() -> [APODResponse] {
        return favoritesCache
    }
}
