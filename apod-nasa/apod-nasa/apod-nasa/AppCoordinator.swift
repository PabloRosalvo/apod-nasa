import UIKit
import Network
class AppCoordinator: Coordinator {
    var window: UIWindow
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: Coordinator?

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        let service = APODService(requestManager: RequestManager())
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController,
                                                          service: service)
        addChild(mainTabBarCoordinator)
        mainTabBarCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
