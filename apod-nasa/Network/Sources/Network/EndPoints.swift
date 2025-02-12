//
//  EndPoints.swift
//  Network
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//

import Foundation

public enum APIEndpoint {
    case apod
    
    public var path: String {
        switch self {
        case .apod:
            return "/v1/exchanges"
        }
    }
}
