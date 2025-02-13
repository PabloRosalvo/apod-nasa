import UIKit
import Combine

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: MainTabBarViewModelProtocol
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    init(viewModel: MainTabBarViewModelProtocol, viewControllers: [UIViewController]) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
