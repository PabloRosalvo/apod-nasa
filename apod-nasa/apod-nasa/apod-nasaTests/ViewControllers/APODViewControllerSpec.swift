import Quick
import Nimble
import Nimble_Snapshots
import Combine
import UIKit

@testable import apod_nasa

final class APODViewControllerSpec: QuickSpec {
    
    override class func spec() {
        describe("APODViewController") {
            
            var sut: APODViewController!
            var mockViewModel: MockAPODViewModel!
            
            beforeEach {
                mockViewModel = MockAPODViewModel(service: MockAPODService(shouldReturnError: false))
                sut = APODViewController(viewModel: mockViewModel)
                sut.view.backgroundColor = .white
                WindowHelper.showInTestWindow(viewController: sut)
            }
            
            afterEach {
                WindowHelper.cleanTestWindow()
            }
            
            context("when the screen is loaded") {
                it("should display the correct title") {
                    expect(sut.title).to(equal("APOD"))
                }
            }
            
            context("when an error occurs") {
                it("should show the error modal") {
                    mockViewModel.isErrorAPI = true
                    
                    expect(sut.view.subviews.contains(where: { $0 is ErrorModalView }))
                        .toEventually(beTrue(), timeout: .seconds(2))
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
