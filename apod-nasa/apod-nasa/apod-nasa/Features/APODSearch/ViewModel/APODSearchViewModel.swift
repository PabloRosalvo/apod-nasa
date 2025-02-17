import Foundation
import Combine

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
            let result = await service.fetchAPOD(date: date)

            guard !Task.isCancelled else {
                self.isErrorAPI = (false, "")
                return
            }

            switch result {
            case .success(let response):
                self.apod = response
                self.isErrorAPI = (false, "")

            case .failure:
                self.isErrorAPI = (true, date)
                self.apod = nil
            }
        }
    }
}
