
import UIKit

final class WindowHelper {
    
    static var testWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        return window
    }()
    
    static func showInTestWindow(viewController: UIViewController) {
        WindowHelper.testWindow.rootViewController = viewController
        WindowHelper.testWindow.isHidden = false
    }
    
    static func cleanTestWindow() {
        WindowHelper.testWindow.rootViewController = nil
        WindowHelper.testWindow.isHidden = true
    }
}
