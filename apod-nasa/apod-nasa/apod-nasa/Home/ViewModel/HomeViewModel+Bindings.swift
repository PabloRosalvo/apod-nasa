//
//  HomeViewModel+Bindings.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//

extension HomeViewModel {
    func setupBindings() {
        primaryButtonTapped
            .sink { [weak self] in
                self?.navigationEvent.send(.goToInfoAPOD)
            }
            .store(in: &cancellables)
    }
}
