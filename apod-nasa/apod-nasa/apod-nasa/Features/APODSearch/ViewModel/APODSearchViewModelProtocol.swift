import Combine
import Foundation

@MainActor
protocol APODSearchViewModelProtocol {
    var apodPublisher: AnyPublisher<APODResponse?, Never> { get }
    func fetchAPOD(for date: String)
    var isError: AnyPublisher<(isError: Bool, date: String), Never> { get }
}
