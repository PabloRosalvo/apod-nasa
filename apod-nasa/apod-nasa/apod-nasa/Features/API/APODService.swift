//
//  HomeServicePOD.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//
import Foundation
@preconcurrency import Network

protocol APODServiceProtocol {
    func fetchAPOD(date: String) async -> Result<APODResponse>
}

final class APODService: APODServiceProtocol, Sendable {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }

    func fetchAPOD(date: String) async -> Result<APODResponse> {
        do {
            let response: APODResponse = try await requestManager.request(
                endpoint: APIEndpoint.apodByDate(date: date)
            )
            return .success(response)
        } catch let error as RequestError {
            return .failure(error)
        } catch {
            return .failure(.networkError("Erro inesperado: \(error.localizedDescription)"))
        }
    }
}
