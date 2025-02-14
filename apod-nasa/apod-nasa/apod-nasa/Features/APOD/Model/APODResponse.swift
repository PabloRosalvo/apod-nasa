//
//  APODResponse.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//
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
