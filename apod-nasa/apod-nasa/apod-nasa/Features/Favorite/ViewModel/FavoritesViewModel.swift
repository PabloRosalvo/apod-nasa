import Combine
import Foundation

final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    var favoritesPublisher: Published<[APODResponse]>.Publisher {
        $favorites
    }
    
    @Published private var favorites: [APODResponse] = []

    private let favoritesManager: FavoritesManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(favoritesManager: FavoritesManagerProtocol) {
        self.favoritesManager = favoritesManager
        bindFavorites()
    }
    
    private func bindFavorites() {
        favoritesManager.favoritesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                self?.favorites = favorites
            }
            .store(in: &cancellables)
    }
    
    func removeFavorite(at index: Int) {
        guard index >= 0, index < favorites.count else { return }
        let favoriteToRemove = favorites[index]
        favoritesManager.removeFavorite(favoriteToRemove)
    }

}
