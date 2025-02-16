import Foundation
import Combine

@MainActor
protocol APODViewModelProtocol {
    var apod: Published<APODResponse?>.Publisher { get }
    var isFavorite: Published<Bool>.Publisher { get }
    var isLoading: Published<Bool>.Publisher { get }
    var isError: Published<Bool>.Publisher { get }
    var primaryButtonTapped: PassthroughSubject<Void, Never> { get }
    var favoriteButtonTapped: PassthroughSubject<Void, Never> { get }
    func viewWillAppear()
}
