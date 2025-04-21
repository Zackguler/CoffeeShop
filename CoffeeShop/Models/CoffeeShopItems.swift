//
//  CoffeeShopItems.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import Foundation

struct CoffeeShopItems: Codable {
    let productId: String
    let title: String
    let type: String
    let imageURL: String
    let price: Double
    let description: String

    enum CodingKeys: String, CodingKey {
        case productId = "productId"
        case title
        case type
        case imageURL = "image_url"
        case price
        case description
    }
}
