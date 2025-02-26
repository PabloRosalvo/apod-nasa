import Combine
import Foundation

protocol APODSearchViewModelProtocol {
    var apodPublisher: Published<APODResponse?>.Publisher { get }
    var isError: Published<(isError: Bool, date: String)>.Publisher { get }
    func fetchAPOD(for date: String)
}
