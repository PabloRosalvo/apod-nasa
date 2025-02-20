import Combine
import Foundation

@testable import apod_nasa

final class MockFavoritesViewModel: FavoritesViewModelProtocol {
    
    @Published private var favorites: [APODResponse] = []
    
    var favoritesPublisher: Published<[APODResponse]>.Publisher { $favorites }

    init() {
        loadFavorites()
    }

    func loadFavorites() {
        favorites = [
            APODResponse(title: "Galáxia de Andrômeda",
                         date: "2024-02-19",
                         explanation: "Descrição teste",
                         url: "image_test_1",
                         mediaType: "image"),
            
            APODResponse(title: "Nebulosa de Órion",
                         date: "2024-02-19",
                         explanation: "Descrição teste",
                         url: "image_test_2",
                         mediaType: "image")
        ]
    }

    func removeFavorite(at index: Int) {
        guard index < favorites.count else { return }
        favorites.remove(at: index)
    }
}
