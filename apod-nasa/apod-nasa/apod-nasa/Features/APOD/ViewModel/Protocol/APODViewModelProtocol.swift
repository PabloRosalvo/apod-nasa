//
//  APODViewModel.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 12/02/25.
//

import Foundation
import Combine

@MainActor
protocol APODViewModelProtocol {
    var titleText: AnyPublisher<String?, Never> { get }
    var descriptionText: AnyPublisher<String?, Never> { get }
    var imageUrlText: AnyPublisher<String?, Never> { get }
    var isFavorite: AnyPublisher<Bool, Never> { get }
    var primaryButtonTapped: PassthroughSubject<Void, Never> { get }
    var favoriteButtonTapped: PassthroughSubject<Void, Never> { get }
    func viewWillAppear()
}
