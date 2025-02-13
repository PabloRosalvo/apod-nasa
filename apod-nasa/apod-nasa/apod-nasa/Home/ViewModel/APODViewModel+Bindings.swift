//
//  APODViewModel+Bindings.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//

extension APODViewModel {
    func setupBindings() {
        primaryButtonTapped
            .sink { [weak self] in
                self?.navigationEvent.send(.goToInfoAPOD)
            }
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .sink { [weak self] in
                guard let self = self, let apod = self.model else { return }
                if self.isFavoriteValue {
                    FavoritesManager.shared.removeFavorite(apod)
                } else {
                    FavoritesManager.shared.saveFavorite(apod)
                }
                self.isFavoriteValue.toggle()
            }
            .store(in: &cancellables)
    }
 
}
