import Quick
import Nimble
import Combine
import Foundation

@testable import apod_nasa

final class APODViewModelSpec: QuickSpec {
    override class func spec() {
        describe("APODViewModel") {
            var sut: APODViewModel!
            var mockService: MockAPODService!
            var cancellables: Set<AnyCancellable>!

            beforeEach {
                cancellables = Set<AnyCancellable>()
            }

            afterEach {
                cancellables = nil
            }

            context("when the API returns success") {
                beforeEach {
                    mockService = MockAPODService(shouldReturnError: false)
                    sut = APODViewModel(service: mockService)
                    sut.fetchAPOD()
                }

                it("should correctly update the APOD and states") {
                    var receivedAPOD: APODResponse?

                    sut.apod
                        .receive(on: DispatchQueue.main)
                        .sink { apod in
                            receivedAPOD = apod
                            expect(receivedAPOD).toEventuallyNot(beNil(), timeout: .seconds(2))
                            expect(receivedAPOD?.title).toEventually(equal("Local Test Image"))
                            expect(receivedAPOD?.url).toEventually(equal("image_test"))
                        }
                        .store(in: &cancellables)
                }
            }
        }
    }
}
