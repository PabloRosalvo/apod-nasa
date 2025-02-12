//
//  ParameterEncoding.swift
//  Network
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public typealias Parameters = [String: Any]

public typealias QueryParameters = [String: Any]

public typealias HTTPHeaders = [String: String]
