import Foundation

enum MainTab: Int {
    case home = 0
    case favorites = 1
    case search = 2
}


enum MainTabNavigationEvent {
    case tabSelected(tab: MainTab)
}

