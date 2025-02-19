import Foundation
import Combine

@MainActor
final class APODSearchViewModel: APODSearchViewModelProtocol {
    
    private let service: APODServiceProtocol
    private var fetchTask: Task<Void, Never>?
    
    @Published private var isErrorAPI: (isError: Bool, date: String) = (false, "")
    @Published private var apod: APODResponse?

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

                self.apod = response
                self.isErrorAPI = (false, "")

            } catch {
                guard !Task.isCancelled else { return }

                self.isErrorAPI = (true, date)
                self.apod = nil
            }
        }
    }

}
