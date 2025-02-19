import Combine
import Foundation

@testable import apod_nasa

final class MockAPODViewModel: APODViewModelProtocol {
    
    @Published var apodValue: APODResponse?
    @Published var isFavoriteValue: Bool = false
    @Published var isLoadingState: Bool = false
    @Published var isErrorAPI: Bool = false

    var apod: Published<APODResponse?>.Publisher { $apodValue }
    var isFavorite: Published<Bool>.Publisher { $isFavoriteValue }
    var isLoading: Published<Bool>.Publisher { $isLoadingState }
    var isError: Published<Bool>.Publisher { $isErrorAPI }
    
    var primaryButtonTapped = PassthroughSubject<Void, Never>()
    var favoriteButtonTapped = PassthroughSubject<Void, Never>()

    private let service: APODServiceProtocol
    private var fetchTask: Task<Void, Never>?

    init(service: APODServiceProtocol) {
        self.service = service
    }

    func viewWillAppear() {
        isLoadingState = true
        isErrorAPI = false

        fetchTask?.cancel()

        fetchTask = Task {
            do {
                let response = try await service.fetchAPOD(date: "2025-02-15")

                guard !Task.isCancelled else { return }
                
                self.apodValue = response
                self.isErrorAPI = false
            } catch {
                guard !Task.isCancelled else { return }
                
                self.isErrorAPI = true
                self.apodValue = nil
                print("Erro ao buscar APOD: \(error.localizedDescription)")
            }
            
            isLoadingState = false
        }
    }
}
