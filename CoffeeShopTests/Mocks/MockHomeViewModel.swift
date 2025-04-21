//
//  MockHomeViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//


import Foundation
@testable import CoffeeShop

final class MockHomeViewModel: HomeViewModelProtocol {
    var isUserLoggedIn: Bool = true

    var fetchCampaignsCalled = false
    var fetchCategoriesCalled = false
    var fetchFavoritesCalled = false

    func fetchCampaigns(completion: @escaping ([Campaign]) -> Void) {
        fetchCampaignsCalled = true
        completion([])
    }

    func fetchCategories(completion: @escaping ([CoffeeShopItems]) -> Void) {
        fetchCategoriesCalled = true
        completion([])
    }

    func fetchFavorites(completion: @escaping ([Favorite]) -> Void) {
        fetchFavoritesCalled = true
        completion([])
    }

    func addToFavorites(_ product: CoffeeShopItems, completion: @escaping (Result<Void, Error>) -> Void) {}
    func removeFromFavorites(productId: String, completion: @escaping (Result<Void, Error>) -> Void) {}
    func isProductFavorited(_ product: CoffeeShopItems) -> Bool { false }
    func toggleFavorite(_ product: CoffeeShopItems, completion: @escaping (Result<Bool, Error>) -> Void) {}
    func refreshFavorites() {}
}
