import Combine
import Foundation

@testable import apod_nasa

final class MockAPODViewModel: APODViewModelProtocol {
    
    @Published private var apodValue: APODResponse?
    @Published private var isFavoriteValue: Bool = false
    @Published private var isLoadingState: Bool = false
    @Published private var isErrorAPI: Bool = false

    var apod: Published<APODResponse?>.Publisher { $apodValue }
    var isFavorite: Published<Bool>.Publisher { $isFavoriteValue }
    var isLoading: Published<Bool>.Publisher { $isLoadingState }
    var isError: Published<Bool>.Publisher { $isErrorAPI }
    
    var primaryButtonTapped = PassthroughSubject<Void, Never>()
    var favoriteButtonTapped = PassthroughSubject<Void, Never>()

    private let service: APODServiceProtocol

    init(service: APODServiceProtocol) {
        self.service = service
    }

    func viewWillAppear() {
        isLoadingState = true
        
        Task {
            let result = await service.fetchAPOD(date: "2025-02-15")
            
            guard !Task.isCancelled else {
                isLoadingState = false
                return
            }
            
            switch result {
            case .success(let response):
                self.apodValue = response
                self.isErrorAPI = false
            case .failure:
                self.isErrorAPI = true
            }
            self.isLoadingState = false
        }
    }
}
