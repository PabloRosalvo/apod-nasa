//
//  FavoritesViewModelSpec.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 19/02/25.
//

import Quick
import Nimble
import Combine
import Foundation

@testable import apod_nasa

final class FavoritesViewModelSpec: QuickSpec {
    override class func spec() {
        describe("FavoritesViewModel") {
            var sut: FavoritesViewModel!
            var mockFavoritesManager: MockFavoritesManager!
            var cancellables: Set<AnyCancellable>!

            beforeEach {
                cancellables = Set<AnyCancellable>()
                mockFavoritesManager = MockFavoritesManager()
                sut = FavoritesViewModel(favoritesManager: mockFavoritesManager)
            }

            afterEach {
                cancellables = nil
                sut = nil
                mockFavoritesManager = nil
            }

            context("when loading favorites") {
                beforeEach {
                    mockFavoritesManager.mockFavorites = [
                        APODResponse(title: "Galáxia de Andrômeda",
                                     date: "2025-02-18",
                                     explanation: "Uma bela galáxia espiral próxima da Via Láctea.",
                                     url: "image_teste",
                                     mediaType: "image"),

                        APODResponse(title: "Nebulosa de Órion",
                                     date: "2025-02-18",
                                     explanation: "Uma das nebulosas mais brilhantes no céu.",
                                     url: "image_teste",
                                     mediaType: "image")

                    ]
                    sut.loadFavorites()
                }

                it("should correctly map and update the favorites list") {
                    var receivedFavorites: [FavoritesListModel] = []

                    sut.favoritesPublisher
                        .sink { favorites in
                            receivedFavorites = favorites
                        }
                        .store(in: &cancellables)

                    expect(receivedFavorites).toEventually(haveCount(2))
                    expect(receivedFavorites.first?.title).toEventually(equal("Galáxia de Andrômeda"))
                    expect(receivedFavorites.first?.mediaURL).toEventually(equal("image_teste"))
                    expect(receivedFavorites.last?.title).toEventually(equal("Nebulosa de Órion"))
                    expect(receivedFavorites.last?.mediaURL).toEventually(equal("image_teste"))
                }
            }

            context("when removing a favorite") {
                beforeEach {
                    mockFavoritesManager.mockFavorites = [
                        APODResponse(title: "Galáxia de Andrômeda",
                                     date: "2025-02-18",
                                     explanation: "Uma bela galáxia espiral próxima da Via Láctea.",
                                     url: "image_teste",
                                     mediaType: "image"),

                        APODResponse(title: "Nebulosa de Órion",
                                     date: "2025-02-18",
                                     explanation: "Uma das nebulosas mais brilhantes no céu.",
                                     url: "image_teste",
                                     mediaType: "image")
                    ]
                    sut.loadFavorites()
                }

                it("should remove the favorite correctly") {
                    sut.removeFavorite(at: 0)

                    var receivedFavorites: [FavoritesListModel] = []
                    sut.favoritesPublisher
                        .sink { favorites in
                            receivedFavorites = favorites
                        }
                        .store(in: &cancellables)

                    expect(receivedFavorites).toEventually(haveCount(1))
                    expect(receivedFavorites.first?.title).toEventually(equal("Nebulosa de Órion"))
                }
            }
        }
    }
}
