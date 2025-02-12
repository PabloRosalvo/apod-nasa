//
//  SecretsManager.swift
//  Network
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//

import Foundation

public final class SecretsManager {
    public static let shared = SecretsManager()
    
    public let apiKey: String
    
    private init() {
        self.apiKey = SecretsManager.loadAPIKey()
    }
    
    private static func loadAPIKey() -> String {
        return "yZIlJnU5lj3eJmsOJs20oOoynRGhAIxaRz75dvRj"
    }
}
