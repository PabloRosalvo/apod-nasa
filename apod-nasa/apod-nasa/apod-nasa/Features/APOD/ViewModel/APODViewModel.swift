import Foundation
import Combine
import Network

@MainActor
final class APODViewModel: APODViewModelProtocol {
    
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()

    private let service: APODServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published private var model: APODResponse?
    @Published private var isFavoriteValue: Bool = false
    @Published private var isLoadingState: Bool = false
    @Published private var isErrorAPI: Bool = false

    var apod: Published<APODResponse?>.Publisher { $model }
    var isFavorite: Published<Bool>.Publisher { $isFavoriteValue }
    var isLoading: Published<Bool>.Publisher { $isLoadingState }
    var isError: Published<Bool>.Publisher { $isErrorAPI }
    
    private var fetchTask: Task<Void, Never>?

    init(service: APODServiceProtocol) {
        self.service = service
        setupBindings()
    }

    func viewWillAppear() {
        fetchAPOD()
    }
    
    func fetchAPOD() {
        isLoadingState = true
        isErrorAPI = false

        fetchTask?.cancel()

        fetchTask = Task {
            defer { isLoadingState = false }

            do {
                let apodData = try await service.fetchAPOD(date: Date().toYYYYMMDD())
                guard !Task.isCancelled else {  return }

                model = apodData
                isFavoriteValue = FavoritesManager.shared.isFavorite(apodData)
            } catch {
                isErrorAPI = true
             }
        }
    }

}

extension APODViewModel {
    func setupBindings() {
        favoriteButtonTapped
            .sink { [weak self] in
                guard let self = self, let apod = self.model else { return }
                if self.isFavoriteValue {
                    FavoritesManager.shared.removeFavorite(apod)
                } else {
                    FavoritesManager.shared.saveFavorite(apod)
                }
                self.isFavoriteValue.toggle()
            }
            .store(in: &cancellables)
    }
}
