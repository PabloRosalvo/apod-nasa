import Foundation
import Combine
import UIKit

protocol MainTabBarViewModelProtocol {
    var tabSelected: PassthroughSubject<MainTab, Never> { get }
    var navigationEvent: PassthroughSubject<MainTabNavigationEvent, Never> { get }
}
