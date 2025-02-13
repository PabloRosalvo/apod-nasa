//
//  FavoritesViewModelProtocol.swift
//  apod-nasa
//
//  Created by Pablo Rosalvo de Melo Lopes on 13/02/25.
//

import Foundation
import Combine

@MainActor
protocol FavoritesViewModelProtocol {
    var favoritesPublisher: Published<[FavoritesListModel]>.Publisher { get } 
    func loadFavorites()
    func removeFavorite(at index: Int)
    func getFavorites() -> [FavoritesListModel]
}

