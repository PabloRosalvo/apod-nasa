import UIKit
import Combine
import Network
@MainActor
final class MainTabBarCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
     func start() {
         let viewModel = MainTabBarViewModel()
         viewModel.navigationEvent
             .sink { [weak self] event in
                 self?.handleNavigation(event)
             }
             .store(in: &cancellables)
         
         
         let viewControllers = MainTabBarController(viewModel: viewModel,
                                                    viewControllers: setupTabs())
        navigationController.pushViewController(viewControllers, animated: true)
    }
    
    private func setupTabs() -> [UIViewController]{
        let service = APODService(requestManager: RequestManager())
        let homeViewController = createHomeViewController(service: service )
        let favoritesViewController = createFavoritesViewController()
        let searchAPODViewController = createSearchViewController()
        
        return [homeViewController,
                favoritesViewController,
                searchAPODViewController]
    }

    private func createHomeViewController(service: APODServiceProtocol) -> UIViewController {
        let viewModel = APODViewModel(service: service)
        let homeViewController = APODViewController(viewModel: viewModel)
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            tag: 0
        )
        bindNavigation(for: viewModel)
        return homeViewController
    }

    private func createFavoritesViewController() -> UIViewController {
        let favoritesViewController = FavoritesViewController(viewModel: FavoritesViewModel())
        favoritesViewController.tabBarItem = UITabBarItem(
            title: "Favoritos",
            image: UIImage(systemName: "star.fill"),
            tag: 1
        )
        return favoritesViewController
    }
    
    private func createSearchViewController() -> UIViewController {
        let viewModel = APODSearchViewModel(service: APODService(requestManager: RequestManager()))
        let searchViewController = APODSearchViewController(viewModel: viewModel)
        searchViewController.tabBarItem = UITabBarItem(
            title: "Buscar",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 2
        )
        return searchViewController
    }
    
    private func bindNavigation(for viewModel: APODViewModel) {
        viewModel.navigationEvent
            .sink { [weak self] event in
                self?.handleNavigation(event)
            }
            .store(in: &cancellables)
    }

    private func handleNavigation(_ event: MainTabNavigationEvent) {
        switch event {
        case .favoriteSelected(viewControler: let viewControler):
            if let homeVC = viewControler as? APODViewController {
                homeVC.viewWillAppear(true)
            }
            if let favoritesVC = viewControler as? FavoritesViewController {
                favoritesVC.viewDidLoad()
            }
        }
    }

}
