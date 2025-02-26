import Combine
import UIKit

final class MainTabBarViewModel: MainTabBarViewModelProtocol {
    
    let tabSelected = PassthroughSubject<MainTab, Never>()
    let navigationEvent = PassthroughSubject<MainTabNavigationEvent, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    private func bind() {
        tabSelected
            .map { MainTabNavigationEvent.tabSelected(tab: $0) }
            .subscribe(navigationEvent)
            .store(in: &cancellables)
    }
}
