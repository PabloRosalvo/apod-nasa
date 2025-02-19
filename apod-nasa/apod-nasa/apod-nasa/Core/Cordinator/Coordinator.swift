import UIKit

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var parentCoordinator: Coordinator? { get set }

    func start()
    func childDidFinish(_ child: Coordinator?)
    func didFinish()
    func addChild(_ child: Coordinator)
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        guard let child = child else { return }
        if let index = childCoordinators.firstIndex(where: { $0 === child }) {
            childCoordinators.remove(at: index)
        }
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }

    func addChild(_ child: Coordinator) {
        childCoordinators.append(child)
    }
}
