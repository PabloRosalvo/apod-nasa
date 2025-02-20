//
//  Publisher+Extension.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 19/02/25.
//

import Combine
import Foundation

extension Publisher where Failure == Never {
    func sinkToMainThread(receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        self.receive(on: DispatchQueue.main)
            .sink(receiveValue: receiveValue)
    }
}
