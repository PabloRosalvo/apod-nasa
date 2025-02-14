import Foundation

public protocol RequestManagerProtocol: Sendable {
    func request<T: Decodable>(
        endpoint: EndPointType
    ) async throws -> T
}

public struct RequestManager: RequestManagerProtocol, Sendable {
    let session: URLSession
    private let apiKey: String

    private let baseURL: String = "https://api.nasa.gov"

    public init(session: URLSession = .shared) {
        self.session = session
        self.apiKey = SecretsManager.shared.apiKey
    }

    public func request<T: Decodable>(
        endpoint: EndPointType
    ) async throws -> T {
        var fullURL = baseURL + endpoint.path
        var queryParams = endpoint.queryParameters

        queryParams["api_key"] = apiKey
        fullURL = addQueryParameters(queryParams, to: fullURL)

        guard let url = URL(string: fullURL) else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue

        if let headers = endpoint.headers {
            request.allHTTPHeaderFields = headers
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw RequestError.invalidResponse
            }

            ResquestLog.requestLog(data: data, response: httpResponse)

            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = String(data: data, encoding: .utf8)
                let jsonResponse = SafeDictionary.from(data: data)
                throw RequestError.httpError(statusCode: httpResponse.statusCode, message: errorMessage, data: jsonResponse)
            }

            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)

        } catch let urlError as URLError {
            throw RequestError.networkError(urlError.localizedDescription)
        } catch {
            throw RequestError.networkError(error.localizedDescription)
        }
    }

    private func addQueryParameters(_ parameters: [String: Any], to url: String) -> String {
        guard var urlComponents = URLComponents(string: url) else { return url }

        let queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }

        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url?.absoluteString ?? url
    }
}
