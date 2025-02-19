import Quick
import Nimble_Snapshots
import Combine
import Nimble
import UIKit

@testable import apod_nasa

import XCTest

final class MainTabBarCoordinatorSpec: QuickSpec {
    override class func spec() {
        describe("MainTabBarCoordinator") {
            var sut: MainTabBarCoordinator!
            var mockNavigationController: UINavigationController!
            var mockService: MockAPODService!

            beforeEach {
                mockService = MockAPODService(shouldReturnError: false)
                mockNavigationController = UINavigationController()

                sut = MainTabBarCoordinator(
                    navigationController: mockNavigationController,
                    service: mockService
                )
                sut.start()
            }

            afterEach {
                WindowHelper.cleanTestWindow()
            }
            
            it("should correctly load MainTabBarController") {
                expect(mockNavigationController.viewControllers.count).to(equal(1))
                expect(mockNavigationController.viewControllers.first).to(beAKindOf(MainTabBarController.self))
            }

            it("should have the correct appearance") {
                WindowHelper.showInTestWindow(nav: mockNavigationController)
                RunLoop.main.run(until: Date().addingTimeInterval(1.0))
                expect(mockNavigationController).toEventually(haveValidSnapshot(), timeout: .seconds(2))
            }
        }
    }
}
