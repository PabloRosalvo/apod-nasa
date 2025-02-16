import Foundation
import Combine
import Network

@MainActor
final class APODViewModel: APODViewModelProtocol {
    
    let primaryButtonTapped = PassthroughSubject<Void, Never>()
    let navigationEvent = PassthroughSubject<MainTabNavigationEvent, Never>()
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

    init(service: APODServiceProtocol) {
        self.service = service
        setupBindings()
    }

    func viewWillAppear() {
        fetchAPOD()
    }
    
    func fetchAPOD() {
        isLoadingState = true
        Task {
            let result = await service.fetchAPOD(date: Date().toYYYYMMDD())
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.model = response
                    self.isFavoriteValue = FavoritesManager.shared.isFavorite(response)
                case .failure(_):
                    self.isErrorAPI = true
                }
                self.isLoadingState = false
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
