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
            var receivedFavorites: [APODResponse] = []
            
            beforeEach {
                cancellables = Set<AnyCancellable>()
                mockFavoritesManager = MockFavoritesManager()
                sut = FavoritesViewModel(favoritesManager: mockFavoritesManager)
                
                sut.favoritesPublisher
                    .sink { receivedFavorites = $0 }
                    .store(in: &cancellables)
            }
            
            afterEach {
                cancellables = nil
                sut = nil
                mockFavoritesManager = nil
                receivedFavorites = []
            }
            
            context("when initializing") {
                it("should start with an empty favorites list") {
                    expect(receivedFavorites).to(beEmpty())
                }
            }
            
            context("when loading favorites") {
                beforeEach {
                    mockFavoritesManager.favoritesCache = [
                        APODResponse(title: "Galáxia de Andrômeda",
                                     date: "2025-02-18",
                                     explanation: "Uma bela galáxia espiral próxima da Via Láctea.",
                                     url: "image_test_1",
                                     mediaType: "image"),
                        
                        APODResponse(title: "Nebulosa de Órion",
                                     date: "2025-02-18",
                                     explanation: "Uma das nebulosas mais brilhantes no céu.",
                                     url: "image_test_2",
                                     mediaType: "image")
                    ]
                }
                
                it("should correctly update the favorites list") {
                    expect(receivedFavorites).toEventually(haveCount(2))
                    expect(receivedFavorites.first?.title).to(equal("Galáxia de Andrômeda"))
                    expect(receivedFavorites.first?.url).to(equal("image_test_1"))
                    expect(receivedFavorites.last?.title).to(equal("Nebulosa de Órion"))
                    expect(receivedFavorites.last?.url).to(equal("image_test_2"))
                }
            }
            
            context("when removing a favorite") {
                beforeEach {
                    mockFavoritesManager.favoritesCache = [
                        APODResponse(title: "Galáxia de Andrômeda",
                                     date: "2025-02-18",
                                     explanation: "Uma bela galáxia espiral próxima da Via Láctea.",
                                     url: "image_test_1",
                                     mediaType: "image"),
                        
                        APODResponse(title: "Nebulosa de Órion",
                                     date: "2025-02-18",
                                     explanation: "Uma das nebulosas mais brilhantes no céu.",
                                     url: "image_test_2",
                                     mediaType: "image")
                    ]
                }
            }
        }
    }
}
