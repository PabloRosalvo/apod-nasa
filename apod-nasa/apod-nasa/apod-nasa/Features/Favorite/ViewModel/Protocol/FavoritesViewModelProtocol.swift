import Foundation
import Combine

@MainActor
protocol FavoritesViewModelProtocol {
    var favoritesPublisher: Published<[APODResponse]>.Publisher { get }
    func removeFavorite(at index: Int)
}
