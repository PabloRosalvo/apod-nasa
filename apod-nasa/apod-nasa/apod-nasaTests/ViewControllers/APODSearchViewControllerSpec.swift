import Quick
import Nimble
import Nimble_Snapshots
import Combine
import UIKit

@testable import apod_nasa

final class APODSearchViewControllerSpec: QuickSpec {
    
    override class func spec() {
        describe("APODSearchViewController") {
            var sut: APODSearchViewController!
            var mockService: MockAPODService!

            var viewModel: APODSearchViewModel!
            
            beforeEach {
                mockService = MockAPODService(shouldReturnError: false)

                viewModel = APODSearchViewModel(service: mockService)
              
                sut = APODSearchViewController(viewModel: viewModel)
                
                WindowHelper.showInTestWindow(viewController: sut)
            }
            
            afterEach {
                WindowHelper.cleanTestWindow()
            }
            
            context("when the screen is loaded") {
                it("should display the correct title") {
                    expect(sut.title).to(equal("Buscar APOD"))
                }
            }
            
            context("when rendering the view") {
                it("should match the expected snapshot") {
                    expect(sut).toEventually(haveValidSnapshot(), timeout: .seconds(2))
                }
            }
        }
    }
}
