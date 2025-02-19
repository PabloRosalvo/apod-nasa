import UIKit

class AppCoordinator: Coordinator {
    var window: UIWindow
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    weak var parentCoordinator: Coordinator?

     init() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.navigationController = UINavigationController()
    }

    func start() {
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        addChild(mainTabBarCoordinator)
        mainTabBarCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
