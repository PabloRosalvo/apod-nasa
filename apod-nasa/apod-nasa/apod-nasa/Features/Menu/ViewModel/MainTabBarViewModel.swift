import Combine
import UIKit

@MainActor
final class MainTabBarViewModel: MainTabBarViewModelProtocol {
    
    let primaryButtonTapped = PassthroughSubject<() -> UIViewController?, Never>()
    let navigationEvent = PassthroughSubject<MainTabNavigationEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    private func bind() {
        primaryButtonTapped
            .compactMap { $0() }
            .map { MainTabNavigationEvent.favoriteSelected(viewControler: $0) }
            .subscribe(navigationEvent)
            .store(in: &cancellables)
    }
}
