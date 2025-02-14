import Quick
import Nimble
import Combine
import Foundation

@testable import apod_nasa

final class APODSearchViewModelSpec: QuickSpec {
    override class func spec() {
        describe("APODSearchViewModel") {
            var sut: APODSearchViewModel!
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
                    sut = APODSearchViewModel(service: mockService)
                    sut.fetchAPOD(for: "2025-02-15")
                }

                it("should update the APOD model correctly") {
                    var receivedAPOD: APODResponse?

                    sut.apodPublisher
                        .receive(on: DispatchQueue.main)
                        .sink { apod in
                            receivedAPOD = apod
                            expect(receivedAPOD).toEventuallyNot(beNil(), timeout: .seconds(2))
                            expect(receivedAPOD?.title).toEventually(equal("Imagem Local de Teste"))
                            expect(receivedAPOD?.url).toEventually(equal("image_teste"))
                        }
                        .store(in: &cancellables)

                  
                }
            }

            context("when the API returns an error") {
                beforeEach {
                    mockService = MockAPODService(shouldReturnError: true)
                    sut = APODSearchViewModel(service: mockService)
                    sut.fetchAPOD(for: "2025-02-15")
                }

                it("should set isErrorAPI to true with the correct date") {
                    var receivedError: (isError: Bool, date: String)?

                    sut.isError
                        .receive(on: DispatchQueue.main)
                        .sink { errorData in
                            receivedError = errorData
                        }
                        .store(in: &cancellables)

                    expect(receivedError?.isError).toEventually(beTrue(), timeout: .seconds(2))
                    expect(receivedError?.date).toEventually(equal("2025-02-15"))
                }
            }
        }
    }
}
