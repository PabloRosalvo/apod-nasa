//
//  EndPointType.swift
//  Network
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//

import Foundation

public protocol EndPointType {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryParameters: [String: Any] { get }
}
