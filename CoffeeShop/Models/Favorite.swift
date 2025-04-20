//
//  Favorite.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import Foundation

struct Favorite: Codable {
    let productId: String
    let title: String
    let price: Double
    let imageURL: String
    let type: String
    let description: String
    let addedAt: Date?

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case title
        case price
        case imageURL = "image_url"
        case type
        case description
        case addedAt = "added_at"
    }
}
