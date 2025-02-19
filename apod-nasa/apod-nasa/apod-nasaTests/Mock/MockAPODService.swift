//
//  MockAPODService.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 14/02/25.
//

import UIKit
import Network

@testable import apod_nasa

@MainActor 
final class MockAPODService: APODServiceProtocol, @unchecked Sendable {
    private let requestManager: RequestManagerProtocol
    private let shouldReturnError: Bool

    init(shouldReturnError: Bool = false, requestManager: RequestManagerProtocol = MockRequestManager()) {
        self.shouldReturnError = shouldReturnError
        self.requestManager = requestManager
    }
    
    func fetchAPOD(date: String) async throws -> APODResponse {
        if shouldReturnError {
            throw RequestError.networkError("Erro simulado na API")
        }

        do {
            return try await requestManager.request(endpoint: MockAPIEndpoint.mockAPOD)
        } catch {
            throw RequestError.networkError("Erro no mock: \(error.localizedDescription)")
        }
    }
}

public enum MockAPIEndpoint: EndPointType {
    case mockAPOD

    public var path: String {
        return ""
    }

    public var httpMethod: HTTPMethod {
        return .get
    }

    public var headers: HTTPHeaders? {
        return [ :  ]
    }

    public var queryParameters: [String: Any] {
        return [:]
    }
}


final class MockRequestManager: RequestManagerProtocol, Sendable {
    private let shouldReturnError: Bool
    private let mockResponse: APODResponse

    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
        self.mockResponse = APODResponse(
            title: "Mocked APOD",
            date: "2025-02-15",
            explanation: "This is a mocked APOD response for testing purposes.",
            url: "image_teste",
            mediaType: "image"
        )
    }

    func request<T: Decodable>(endpoint: EndPointType) async throws -> T {
        if shouldReturnError {
            throw RequestError.networkError("Simulated network error")
        } else {
            guard let response = mockResponse as? T else {
                throw RequestError.invalidResponse
            }
            return response
        }
    }
}

