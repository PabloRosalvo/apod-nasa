import Foundation
import Network

protocol APODServiceProtocol {
    func fetchAPOD(date: String) async throws -> APODResponse
}

final class APODService: APODServiceProtocol, Sendable {
    private let requestManager: RequestManagerProtocol & Sendable

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }

    func fetchAPOD(date: String) async throws -> APODResponse {
        return try await requestManager.request(
            endpoint: APIEndpoint.apodByDate(date: date)
        )
    }

}
