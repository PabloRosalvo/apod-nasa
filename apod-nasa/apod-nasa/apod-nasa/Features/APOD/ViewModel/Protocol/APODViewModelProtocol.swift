import Foundation
import Combine

@MainActor
protocol APODViewModelProtocol {
    var apod: AnyPublisher<APODResponse?, Never> { get }
    var isFavorite: AnyPublisher<Bool, Never> { get }
    var primaryButtonTapped: PassthroughSubject<Void, Never> { get }
    var favoriteButtonTapped: PassthroughSubject<Void, Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
    var isError: AnyPublisher<Bool, Never> { get }

    func viewWillAppear()
}
