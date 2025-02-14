//
//  APODSearchViewModel.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//

import Foundation
import Combine

@MainActor
protocol SearchAPODViewModelProtocol {
    var apodPublisher: AnyPublisher<APODResponse?, Never> { get }
    func fetchAPOD(for date: String)
}

final class SearchAPODViewModel: SearchAPODViewModelProtocol {
    
    private let service: APODServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published private var apod: APODResponse?

    var apodPublisher: AnyPublisher<APODResponse?, Never> {
        $apod.eraseToAnyPublisher()
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
                case .failure(let error):
                    print("Erro ao buscar APOD: \(error.localizedDescription)")
                    self.apod = nil
                }
            }
        }
    }
}

