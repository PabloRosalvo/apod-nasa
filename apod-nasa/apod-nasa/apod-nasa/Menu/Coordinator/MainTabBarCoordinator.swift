import UIKit
import Combine

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
        let homeViewController = createHomeViewController()
        let favoritesViewController = createFavoritesViewController()
        return [homeViewController, favoritesViewController]
    }

    private func createHomeViewController() -> UIViewController {
        let viewModel = APODViewModel(service: HomeAPODService())
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

    private func bindNavigation(for viewModel: APODViewModel) {
        viewModel.navigationEvent
            .sink { [weak self] event in
                self?.handleNavigation(event)
            }
            .store(in: &cancellables)
    }

    private func handleNavigation(_ event: MainTabNavigationEvent) {
        switch event {
        case .goToInfoAPOD:
            showInfoAPODScreen()
        case .favoriteSelected(viewControler: let viewControler):
            if let homeVC = viewControler as? APODViewController {
                homeVC.viewWillAppear(true)
            }
            if let favoritesVC = viewControler as? FavoritesViewController {
                favoritesVC.viewDidLoad()
            }
        }
    }

    private func showInfoAPODScreen() {
        print("Navegar para detalhes do APOD")
    }
}
