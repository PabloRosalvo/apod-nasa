//
//  MockAPODService.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 14/02/25.
//


import UIKit
import Network

@testable @preconcurrency import apod_nasa

final class MockAPODService: APODServiceProtocol {
    var shouldReturnError: Bool
    let requestManager: RequestManagerProtocol

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
        return "/mock/planetary/apod"
    }

    public var httpMethod: HTTPMethod {
        return .get
    }

    public var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }

    public var queryParameters: [String: Any] {
        return [:]
    }
}



final class MockRequestManager: RequestManagerProtocol {
    let shouldReturnError: Bool
    let mockResponse: APODResponse

    init(shouldReturnError: Bool = false) {
        self.shouldReturnError = shouldReturnError
        self.mockResponse = APODResponse(
            title: "Mocked APOD",
            date: "2025-02-15",
            explanation: "This is a mocked APOD response for testing purposes.",
            url: "https://apod.nasa.gov/apod/image/MockImage.jpg",
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
