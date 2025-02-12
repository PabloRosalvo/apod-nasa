//
//  RequestError.swift
//  Network
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//

import Foundation

public final class RequestError: Error, Sendable {
    public let statusCode: HTTPStatusCode
    public let reason: String
    public let data: SafeDictionary?  // ✅ Agora `SafeDictionary` é Sendable

    public init(reason: String = "", statusCode: Int? = 0, json: SafeDictionary? = nil) {
        self.reason = reason
        self.statusCode = HTTPStatusCode(rawValue: statusCode ?? 0) ?? .invalidStatus
        self.data = json
    }
}

public struct SafeDictionary: Sendable {
    let values: [String: CodableValue]

    init(values: [String: CodableValue]) {
        self.values = values
    }
}

// 🔹 Apenas valores `Sendable` são permitidos
public enum CodableValue: Sendable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
}
