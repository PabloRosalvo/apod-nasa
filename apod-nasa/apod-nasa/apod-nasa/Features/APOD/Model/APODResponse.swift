import Foundation

public struct APODResponse: Codable {
    public let title: String
    public let date: String
    public let explanation: String
    public let url: String?
    public let mediaType: String?

    enum CodingKeys: String, CodingKey {
        case title, date, explanation, url
        case mediaType = "media_type"
    }
}
