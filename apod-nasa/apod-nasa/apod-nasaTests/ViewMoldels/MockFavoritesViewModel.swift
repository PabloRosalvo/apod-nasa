import Combine
import Foundation

@testable import apod_nasa

final class MockFavoritesViewModel: FavoritesViewModelProtocol {
    
    @Published private var favorites: [FavoritesListModel] = []
    
    var favoritesPublisher: Published<[FavoritesListModel]>.Publisher { $favorites }

    func loadFavorites() {
        favorites = [
            FavoritesListModel(title: "Galáxia de Andrômeda", mediaURL: "image_teste"),
            FavoritesListModel(title: "Nebulosa de Órion", mediaURL: "image_teste")
        ]
    }

    func getFavorites() -> [FavoritesListModel] {
        return favorites
    }

    func removeFavorite(at index: Int) {
        guard index < favorites.count else { return }
        favorites.remove(at: index)
    }
}
