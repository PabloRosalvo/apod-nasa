import Foundation
import Combine

protocol APODViewModelProtocol {
    var apod: Published<APODResponse?>.Publisher { get }
    var isFavorite: Published<Bool>.Publisher { get }
    var isLoading: Published<Bool>.Publisher { get }
    var isError: Published<Bool>.Publisher { get }
    var favoriteButtonTapped: PassthroughSubject<Void, Never> { get }
    
    func viewWillAppear()
}
