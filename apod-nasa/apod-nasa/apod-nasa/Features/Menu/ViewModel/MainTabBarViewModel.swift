import Combine
import UIKit

@MainActor
final class MainTabBarViewModel: MainTabBarViewModelProtocol {
    let primaryButtonTapped = PassthroughSubject<() -> UIViewController?, Never>()
    let navigationEvent = PassthroughSubject<MainTabNavigationEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        primaryButtonTapped
            .sink { [weak self] viewControllerProvider in
                guard let viewController = viewControllerProvider() else { return }
                self?.navigationEvent.send(
                    .favoriteSelected(viewControler: viewController)
                )
            }
            .store(in: &cancellables)
    }
}
