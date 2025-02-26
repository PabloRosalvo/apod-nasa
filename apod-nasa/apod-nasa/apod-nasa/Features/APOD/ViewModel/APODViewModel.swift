import Foundation
import Combine
import Network

final class APODViewModel: APODViewModelProtocol {
    
    @Published private(set) var model: APODResponse?
    @Published private(set) var isFavoriteValue: Bool = false
    @Published private(set) var isLoadingState: Bool = false
    @Published private(set) var isErrorAPI: Bool = false
    
    var apod: Published<APODResponse?>.Publisher { $model }
    var isFavorite: Published<Bool>.Publisher { $isFavoriteValue }
    var isLoading: Published<Bool>.Publisher { $isLoadingState }
    var isError: Published<Bool>.Publisher { $isErrorAPI }

    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    
    private let service: APODServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var fetchTask: Task<Void, Never>?
    private let favoritesManager: FavoritesManagerProtocol
    
    init(service: APODServiceProtocol,
         favoritesManager: FavoritesManagerProtocol) {
        self.favoritesManager = favoritesManager
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
            do {
                let apodData = try await service.fetchAPOD(date: Date().toYYYYMMDD())
                guard !Task.isCancelled else { return }

                await MainActor.run {
                    self.model = apodData
                    self.isFavoriteValue = self.favoritesManager.isFavorite(apodData)
                    self.isLoadingState = false
                }
            } catch {
                await MainActor.run {
                    self.isErrorAPI = true
                    self.isLoadingState = false
                }
            }
        }
    }

}

extension APODViewModel {
    private func setupBindings() {
        favoriteButtonTapped
            .sink { [weak self] in
                guard let self = self, let apod = self.model else { return }
                self.toggleFavorite(apod: apod)
            }
            .store(in: &cancellables)
    }

    private func toggleFavorite(apod: APODResponse) {
        if isFavoriteValue {
            favoritesManager.removeFavorite(apod)
        } else {
            favoritesManager.saveFavorite(apod)
        }
        isFavoriteValue.toggle()
    }
}
