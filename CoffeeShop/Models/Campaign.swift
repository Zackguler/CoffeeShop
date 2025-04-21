//
//  Campaign.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import Foundation
import FirebaseFirestore

struct Campaign: Codable {
    let productId: String
    let title: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case productId = "productId"
        case title
        case imageURL = "image_url"
    }
}
