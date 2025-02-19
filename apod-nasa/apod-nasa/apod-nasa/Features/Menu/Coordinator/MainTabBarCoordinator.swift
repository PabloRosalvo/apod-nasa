import UIKit
import Combine
import Network


@MainActor
final class MainTabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    private var cancellables = Set<AnyCancellable>()
    
    private let service: APODServiceProtocol

    init(navigationController: UINavigationController, service: APODServiceProtocol) {
        self.service = service
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = MainTabBarViewModel()
        viewModel.navigationEvent
            .sink { [weak self] event in
                self?.handleNavigation(event)
            }
            .store(in: &cancellables)
        
        let tabBarController = createTabBarController(viewModel: viewModel)
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func createTabBarController(viewModel: MainTabBarViewModel) -> MainTabBarController {
        let homeVC = createHomeViewController(service: service)
        let favoritesVC = createFavoritesViewController()
        let searchVC = createSearchViewController()
        
        let viewControllers: [(UIViewController, MainTab)] = [
            (homeVC, .home),
            (favoritesVC, .favorites),
            (searchVC, .search)
        ]
        
        return MainTabBarController(viewModel: viewModel, viewControllers: viewControllers)
    }

    private func createHomeViewController(service: APODServiceProtocol) -> UIViewController {
        let viewModel = APODViewModel(service: service)
        let homeViewController = APODViewController(viewModel: viewModel)
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        return homeViewController
    }
    
    private func createFavoritesViewController() -> UIViewController {
        let viewModel = FavoritesViewModel(
            favoritesManager: FavoritesManager.shared
        )
        let favoritesViewController = FavoritesViewController(viewModel: viewModel)
        favoritesViewController.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "star.fill"),
            tag: 1
        )
        return favoritesViewController
    }
    
    private func createSearchViewController() -> UIViewController {
        let viewModel = APODSearchViewModel(service: service)
        let searchViewController = APODSearchViewController(viewModel: viewModel)
        searchViewController.tabBarItem = UITabBarItem(
            title: "Buscar",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 2
        )
        return searchViewController
    }
    
    private func handleNavigation(_ event: MainTabNavigationEvent) {
        switch event {
        case .tabSelected(let tab):
            handleTabSelection(tab)
        }
    }
    
    private func handleTabSelection(_ tab: MainTab) {
        if let tabBarController = navigationController.viewControllers.first as? UITabBarController,
           let selectedNavController = tabBarController.selectedViewController as? UINavigationController {
            
            switch tab {
            case .home:
                if let homeVC = selectedNavController.topViewController as? APODViewController {
                    homeVC.viewWillAppear(true)
                }
            case .favorites:
                if let favoritesVC = selectedNavController.topViewController as? FavoritesViewController {
                    favoritesVC.viewDidLoad()
                }
            case .search:
                break
            }
        }
    }
}
