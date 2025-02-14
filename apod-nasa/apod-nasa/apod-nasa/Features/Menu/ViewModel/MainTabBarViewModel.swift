//
//  Untitled.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//

//
//  HomeViewModel.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//
import Combine
import UIKit

@MainActor
final class MainTabBarViewModel: MainTabBarViewModelProtocol {
    let primaryButtonTapped = PassthroughSubject<UIViewController, Never>()
    let navigationEvent = PassthroughSubject<MainTabNavigationEvent, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        primaryButtonTapped
            .sink { [weak self] viewController in
                self?.navigationEvent.send(.favoriteSelected(
                    viewControler: viewController)
                )
            }
            .store(in: &cancellables)
    }
    
}
