//
//  APODViewModel.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//
import Foundation
import Combine
import Network

@MainActor
final class APODViewModel: APODViewModelProtocol {
    let primaryButtonTapped = PassthroughSubject<Void, Never>()
    let navigationEvent = PassthroughSubject<MainTabNavigationEvent, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()

    var cancellables = Set<AnyCancellable>()
    private let service: APODServiceProtocol

    @Published var model: APODResponse?
    @Published var isFavoriteValue: Bool = false

    var titleText: AnyPublisher<String?, Never> {
        $model.map { $0?.title }.eraseToAnyPublisher()
    }
    
    var descriptionText: AnyPublisher<String?, Never> {
        $model.map { $0?.explanation }.eraseToAnyPublisher()
    }
    
    var imageUrlText: AnyPublisher<String?, Never> {
        $model.map { $0?.url }.eraseToAnyPublisher()
    }

    var isFavorite: AnyPublisher<Bool, Never> {
        $isFavoriteValue.eraseToAnyPublisher()
    }

    init(service: APODServiceProtocol) {
        self.service = service
        setupBindings()
    }

    func viewWillAppear() {
        fetchAPOD()
    }
    
    func fetchAPOD() {
        Task {
            let result = await service.fetchAPOD(date: "2025-02-13")
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.model = response
                    self.isFavoriteValue = FavoritesManager.shared.isFavorite(response)
                case .failure(let error):
                    print("Erro: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
