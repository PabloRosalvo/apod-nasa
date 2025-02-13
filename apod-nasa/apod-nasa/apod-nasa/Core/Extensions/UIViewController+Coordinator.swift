import UIKit
import ObjectiveC

extension UIViewController {
    private static var associationKey: UInt8 = 0
    weak var coordinator: Coordinator? {
        get {
            return objc_getAssociatedObject(self, &UIViewController.associationKey) as? Coordinator
        }
        set {
            objc_setAssociatedObject(self, &UIViewController.associationKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    static let swizzleViewWillDisappear: Void = {
        let originalSelector = #selector(viewWillDisappear(_:))
        let swizzledSelector = #selector(swizzled_viewWillDisappear(_:))

        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
            return
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    @objc private func swizzled_viewWillDisappear(_ animated: Bool) {
        swizzled_viewWillDisappear(animated)
        if self.isMovingFromParent {
            coordinator?.didFinish()
        }
    }
}

extension UIApplication {
    private static let runOnce: Void = {
        UIViewController.swizzleViewWillDisappear
    }()
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}
