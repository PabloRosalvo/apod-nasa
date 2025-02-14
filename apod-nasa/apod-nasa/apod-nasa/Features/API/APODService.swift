import Foundation
import Network

protocol APODServiceProtocol {
    func fetchAPOD(date: String) async -> Result<APODResponse>
}

final class APODService: APODServiceProtocol, Sendable {
    private let requestManager: RequestManagerProtocol & Sendable

    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }

    func fetchAPOD(date: String) async -> Result<APODResponse> {
        return await Task.detached(priority: .background) {
            do {
                let response: APODResponse = try await self.requestManager.request(
                    endpoint: APIEndpoint.apodByDate(date: date)
                )
                return .success(response)
            } catch let error as RequestError {
                return .failure(error)
            } catch {
                return .failure(.networkError("Erro inesperado: \(error.localizedDescription)"))
            }
        }.value
    }
}
