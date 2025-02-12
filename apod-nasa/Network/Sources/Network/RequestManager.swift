//
//  RequestManager.swift
//  Network
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//

import Foundation

import Foundation

protocol RequestManagerProtocol {
    func request<T: Decodable>(
        baseURL: String,
        endpoint: APIEndpoint,
        method: HTTPMethodV2,
        parameters: ParametersV2?,
        headers: HTTPHeadersV2?
    ) async throws -> T
}

import Foundation

public struct RequestManager: RequestManagerProtocol {
    let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func request<T: Decodable>(
        baseURL: String,
        endpoint: APIEndpoint,
        method: HTTPMethodV2 = .get,
        parameters: ParametersV2? = nil,
        headers: HTTPHeadersV2? = nil
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw RequestError(reason: "Invalid URL", statusCode: 400)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        var updatedHeaders = headers ?? [:]
        updatedHeaders["X-CoinAPI-Key"] = "32524CF9-75BF-4A4A-93AA-460402AC4C2E"
        request.allHTTPHeaderFields = updatedHeaders

        if let parameters = parameters {
            request.httpBody = convertJsonForData(json: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw RequestError(reason: "Invalid response", statusCode: nil)
            }

            ResquestLog.requestLog(data: data, response: httpResponse, error: nil)

            guard (200...299).contains(httpResponse.statusCode) else {
                throw RequestError(reason: "HTTP Error", statusCode: httpResponse.statusCode, json: nil)
            }

            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)

            return decodedData
        } catch {
            throw RequestError(reason: "Request failed: \(error.localizedDescription)", statusCode: nil)
        }
    }

    private func convertJsonForData(json: [String: Any]?) -> Data? {
        guard let json = json else { return nil }
        return try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
    }
}
