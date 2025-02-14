//
//  Untitled.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 14/02/25.
//
import Combine
import Foundation

@testable import apod_nasa

final class MockAPODViewModel: APODViewModelProtocol {
    
    private let service: APODServiceProtocol
    
    var apodSubject = PassthroughSubject<APODResponse?, Never>()
    var isFavoriteSubject = PassthroughSubject<Bool, Never>()
    var isLoadingSubject = PassthroughSubject<Bool, Never>()
    var isErrorSubject = PassthroughSubject<Bool, Never>()

    var apod: AnyPublisher<APODResponse?, Never> {
        apodSubject.eraseToAnyPublisher()
    }

    var isFavorite: AnyPublisher<Bool, Never> {
        isFavoriteSubject.eraseToAnyPublisher()
    }

    var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }

    var isError: AnyPublisher<Bool, Never> {
        isErrorSubject.eraseToAnyPublisher()
    }

    var primaryButtonTapped = PassthroughSubject<Void, Never>()
    var favoriteButtonTapped = PassthroughSubject<Void, Never>()

    init(service: APODServiceProtocol) {
        self.service = service
    }

    func viewWillAppear() {
        Task {
            let result = await service.fetchAPOD(date: "2025-02-15")
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.apodSubject.send(response)
                case .failure:
                    self.isErrorSubject.send(true)
                }
            }
        }
    }
}

