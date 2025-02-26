import Foundation
import Combine

protocol APODSearchViewModelProtocol {
    var apodPublisher: Published<APODResponse?>.Publisher { get }
    var isError: Published<(isError: Bool, date: String)>.Publisher { get }
    func fetchAPOD(for date: String)
}

final class APODSearchViewModel: APODSearchViewModelProtocol {
    
    private let service: APODServiceProtocol
    private var fetchTask: Task<Void, Never>?
    
    @Published private(set) var isErrorAPI: (isError: Bool, date: String) = (false, "")
    @Published private(set) var apod: APODResponse?

    var apodPublisher: Published<APODResponse?>.Publisher { $apod }
    var isError: Published<(isError: Bool, date: String)>.Publisher { $isErrorAPI }
    
    init(service: APODServiceProtocol) {
        self.service = service
    }

    func fetchAPOD(for date: String) {
        fetchTask?.cancel()

        fetchTask = Task {
            do {
                let response = try await service.fetchAPOD(date: date)
                
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.apod = response
                    self.isErrorAPI = (false, "")
                }
            } catch {
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.isErrorAPI = (true, date)
                    self.apod = nil
                }
            }
        }
    }
}
