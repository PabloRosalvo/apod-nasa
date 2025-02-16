import Foundation
import Combine

@MainActor
final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    @Published private var favorites: [FavoritesListModel] = []
    var favoritesPublisher: Published<[FavoritesListModel]>.Publisher { $favorites }
    
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
