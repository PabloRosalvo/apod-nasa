import Quick
import Nimble
import Foundation

@testable import apod_nasa

final class MockFavoritesManagerSpec: QuickSpec {
    
    override class func spec() {
        describe("MockFavoritesManager") {
            
            var sut: MockFavoritesManager!
            let mockAPOD1 = APODResponse(
                title: "Galáxia de Andrômeda",
                date: "2025-02-15",
                explanation: "Uma belíssima galáxia.",
                url: "https://apod.nasa.gov/apod/image/Andromeda.jpg",
                mediaType: "image"
            )
            
            beforeEach {
                sut = MockFavoritesManager()
            }
            
            context("when adding a favorite") {
                it("should correctly add an APOD to favorites") {
                    sut.saveFavorite(mockAPOD1)
                    
                    expect(sut.getFavorites().count).to(equal(1))
                }
                
                it("should not add duplicate APODs to favorites") {
                    sut.saveFavorite(mockAPOD1)
                    sut.saveFavorite(mockAPOD1)
                    
                    expect(sut.getFavorites().count).to(equal(1))
                }
            }
            
            context("when removing a favorite") {
                it("should correctly remove an APOD from favorites") {
                    sut.saveFavorite(mockAPOD1)
                    sut.removeFavorite(mockAPOD1)
                    
                    expect(sut.getFavorites().count).to(equal(0))
                }
            }
            
            context("when checking if an APOD is a favorite") {
                it("should return true if the APOD is a favorite") {
                    sut.saveFavorite(mockAPOD1)
                    
                    expect(sut.isFavorite(mockAPOD1)).to(beTrue())
                }
                
                it("should return false if the APOD is not a favorite") {
                    expect(sut.isFavorite(mockAPOD1)).to(beFalse())
                }
            }
            
            context("when toggling a favorite") {
                it("should correctly toggle an APOD from not favorite to favorite") {
                    sut.toggleFavorite(mockAPOD1)
                    
                    expect(sut.isFavorite(mockAPOD1)).to(beTrue())
                }
                
                it("should correctly toggle an APOD from favorite to not favorite") {
                    sut.toggleFavorite(mockAPOD1)
                    sut.toggleFavorite(mockAPOD1)
                    
                    expect(sut.isFavorite(mockAPOD1)).to(beFalse())
                }
            }
        }
    }
}
