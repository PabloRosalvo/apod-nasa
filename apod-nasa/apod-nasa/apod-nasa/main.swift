//
//  main.swift.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 19/02/25.
//

import UIKit

private func isRunningTests() -> Bool {
    return NSClassFromString("XCTestCase") != nil
}

let appDelegateClass: AnyClass = isRunningTests() ? TestingAppDelegate.self : AppDelegate.self

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(appDelegateClass)
)

final class TestingAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}
