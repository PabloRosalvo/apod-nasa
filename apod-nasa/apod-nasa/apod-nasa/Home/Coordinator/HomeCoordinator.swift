import UIKit
import Combine

@MainActor
final class HomeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
     func start() {
        let viewModel = HomeViewModel(service: HomeAPODService())
        viewModel.navigationEvent
            .sink { [weak self] event in
                self?.handleNavigation(event)
            }
            .store(in: &cancellables)
        let homeViewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    func handleNavigation(_ event: HomeNavigationEvent) {
        switch event {
        case .goToInfoAPOD:
            showInfoAPODScreen()
        }
    }

    
    private func showInfoAPODScreen() {
        print("")
    }
    
}
