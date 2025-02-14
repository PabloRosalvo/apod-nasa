import Foundation
import Combine

final class APODSearchViewModel: APODSearchViewModelProtocol {
    
    private let service: APODServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published private var isErrorAPI: (isError: Bool, date: String) = (false, "")
    @Published private var apod: APODResponse?

    var apodPublisher: AnyPublisher<APODResponse?, Never> {
        $apod.eraseToAnyPublisher()
    }
    
    var isError: AnyPublisher<(isError: Bool, date: String), Never> {
        $isErrorAPI.eraseToAnyPublisher()
    }
    
    init(service: APODServiceProtocol) {
        self.service = service
    }

    func fetchAPOD(for date: String) {
        Task {
            let result = await service.fetchAPOD(date: date)
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.apod = response
                case .failure(_):
                    self.isErrorAPI = (true, date)
                    self.apod = nil
                }
            }
        }
    }
}

