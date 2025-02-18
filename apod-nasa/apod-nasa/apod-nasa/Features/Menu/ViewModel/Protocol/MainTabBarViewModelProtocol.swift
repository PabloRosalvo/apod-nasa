import Foundation
import Combine
import UIKit

@MainActor
protocol MainTabBarViewModelProtocol {
    var primaryButtonTapped: PassthroughSubject<() -> UIViewController?, Never> { get }
    var navigationEvent: PassthroughSubject<MainTabNavigationEvent, Never> { get }
}
