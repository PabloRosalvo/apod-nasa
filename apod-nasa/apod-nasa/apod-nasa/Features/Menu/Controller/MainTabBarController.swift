import UIKit
import Combine

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let viewModel: MainTabBarViewModelProtocol
    
    init(viewModel: MainTabBarViewModelProtocol, viewControllers: [(UIViewController, MainTab)]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0.0) }
        delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTabBarController {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        guard let selectedTab = MainTab(rawValue: index) else { return }
        viewModel.tabSelected.send(selectedTab)
    }
}
