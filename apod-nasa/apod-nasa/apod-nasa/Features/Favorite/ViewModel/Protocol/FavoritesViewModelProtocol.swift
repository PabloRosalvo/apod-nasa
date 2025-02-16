import Foundation
import Combine

@MainActor
protocol FavoritesViewModelProtocol {
    var favoritesPublisher: Published<[FavoritesListModel]>.Publisher { get }
    func loadFavorites()
    func removeFavorite(at index: Int)
    func getFavorites() -> [FavoritesListModel]
}
