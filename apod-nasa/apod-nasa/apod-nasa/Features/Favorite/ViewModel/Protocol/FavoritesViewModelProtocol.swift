import Foundation
import Combine

@MainActor
protocol FavoritesViewModelProtocol {
    var favoritesPublisher: AnyPublisher<[FavoritesListModel], Never> { get }
    func loadFavorites()
    func removeFavorite(at index: Int)
    func getFavorites() -> [FavoritesListModel]
}
