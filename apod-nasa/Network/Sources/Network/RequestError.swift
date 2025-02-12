//
//  RequestError.swift
//  Network
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//

import Foundation

public enum RequestError: Error, Sendable {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int, message: String?, data: SafeDictionary?)
    case decodingError(String)
    case networkError(String)
    
    public var errorMessage: String {
        switch self {
        case .invalidURL:
            return "URL inválida."
        case .invalidResponse:
            return "A resposta do servidor é inválida."
        case let .httpError(statusCode, message, _):
            return "Erro HTTP (\(statusCode)): \(message ?? "Sem detalhes disponíveis.")"
        case let .decodingError(description):
            return "Erro ao decodificar os dados: \(description)"
        case let .networkError(description):
            return "Erro de conexão: \(description)"
        }
    }
}

public struct SafeDictionary: Sendable {
    let values: [String: CodableValue]

    init(values: [String: CodableValue]) {
        self.values = values
    }

    public static func from(data: Data?) -> SafeDictionary? {
        guard let data = data,
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }

        let safeValues = jsonObject.compactMapValues { value -> CodableValue? in
            switch value {
            case let string as String:
                return .string(string)
            case let int as Int:
                return .int(int)
            case let double as Double:
                return .double(double)
            case let bool as Bool:
                return .bool(bool)
            default:
                return nil
            }
        }

        return SafeDictionary(values: safeValues)
    }
}

public enum CodableValue: Sendable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
}
