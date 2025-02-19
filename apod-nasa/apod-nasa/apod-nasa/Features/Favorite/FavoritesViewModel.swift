import Foundation
import Combine

@MainActor
final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    @Published private var favorites: [FavoritesListModel] = []
    var favoritesPublisher: Published<[FavoritesListModel]>.Publisher { $favorites }
    private let favoritesManager: FavoritesManagerProtocol

    init(favoritesManager: FavoritesManagerProtocol) {
        self.favoritesManager = favoritesManager
    }
    
    func getFavorites() -> [FavoritesListModel] {
        return favorites
    }
    
    func loadFavorites() {
        let favoriteAPODs = favoritesManager.getFavorites()
        favorites = favoriteAPODs.map { FavoritesListModel(title: $0.title, mediaURL: $0.url) }
    }
    
    func removeFavorite(at index: Int) {
        let favoriteToRemove = favoritesManager.getFavorites()[index]
        favoritesManager.removeFavorite(favoriteToRemove)
        loadFavorites()
    }
}
