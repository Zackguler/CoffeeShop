//
//  CoffeeShopItems.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import Foundation

struct CoffeeShopItems: Codable {
    let id: String
    let title: String
    let type: String
    let imageURL: String
    let price: Double
    let description: String

    enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case title
        case type
        case imageURL = "image_url"
        case price
        case description
    }
}
