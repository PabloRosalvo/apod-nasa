import Combine
import UIKit

@MainActor
final class MainTabBarViewModel: MainTabBarViewModelProtocol {
    let primaryButtonTapped = PassthroughSubject<UIViewController, Never>()
    let navigationEvent = PassthroughSubject<MainTabNavigationEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        primaryButtonTapped
            .sink { [weak self] viewController in
                self?.navigationEvent.send(
                    .favoriteSelected(viewControler: viewController)
                )
            }
            .store(in: &cancellables)
    }
    
}
