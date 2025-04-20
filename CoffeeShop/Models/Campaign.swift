//
//  Campaign.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import Foundation
import FirebaseFirestore

struct Campaign: Codable {
    let id: String
    let title: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image_url"
    }
}
