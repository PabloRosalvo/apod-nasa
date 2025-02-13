//
//  HomeViewModel.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//

import Foundation
import Combine
import Network

@MainActor
final class HomeViewModel: HomeViewModelProtocol {
    
    let primaryButtonTapped = PassthroughSubject<Void, Never>()
    let navigationEvent = PassthroughSubject<HomeNavigationEvent, Never>()

    var cancellables = Set<AnyCancellable>()
    
    let service: APODServiceProtocol
    

    var titleText: AnyPublisher<String?, Never> {
        $model.map { $0?.title }.eraseToAnyPublisher()
    }
    
    var descriptionText: AnyPublisher<String?, Never> {
        $model.map { $0?.explanation }.eraseToAnyPublisher()
    }
    
    var imageUrlText: AnyPublisher<String?, Never> {
        $model.map { $0?.url }.eraseToAnyPublisher()
    }

    @Published private(set) var model: APODResponse?

    init(service: APODServiceProtocol) {
        self.service = service
    }

    func viewWillAppear() {
        setupBindings()
        fetchAPOD()
    }
    
    func fetchAPOD() {
        Task {
            let result = await service.fetchAPOD(date: Date().toYYYYMMDD())
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.model = response
                case .failure(let error):
                    print("Erro: \(error.localizedDescription)")
                }
            }
        }
    }
}



