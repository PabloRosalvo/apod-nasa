//
//  FavoritesViewControllerSpec.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 14/02/25.
//

import Quick
import Nimble_Snapshots
import Combine
import Nimble
import UIKit

@testable import apod_nasa

final class FavoritesViewControllerSpec: QuickSpec {
    override class func spec() {
        describe("FavoritesViewController") {
            var sut: FavoritesViewController!
            var mockViewModel: MockFavoritesViewModel!

            beforeEach {
                mockViewModel = MockFavoritesViewModel()
                sut = FavoritesViewController(viewModel: mockViewModel)
                sut.view.backgroundColor = .white
                WindowHelper.showInTestWindow(viewController: sut)
            }

            afterEach {
                WindowHelper.cleanTestWindow()
            }

            context("when the screen loads") {
                it("should have the correct appearance") {
                    expect(sut).toEventually(haveValidSnapshot(), timeout: .seconds(2))
                }
            }
        }
    }
}
