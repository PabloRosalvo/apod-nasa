//
//  MainTabBarController+TabDelegate.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//
import UIKit

extension MainTabBarController {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        guard let navController = viewController as? UINavigationController,
              let topViewController = navController.topViewController else { return }
        viewModel.primaryButtonTapped.send { topViewController }
    }
}
