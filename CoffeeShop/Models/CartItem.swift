//
//  CartItem.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

struct CartItem: Codable {
    let productId: String
    let title: String
    let imageURL: String
    var quantity: Int
    let price: Double
}

extension CartItem {
    init?(from dict: [String: Any]) {
        guard
            let productId = dict["productId"] as? String,
            let title = dict["title"] as? String,
            let imageURL = dict["image_url"] as? String,
            let quantity = dict["quantity"] as? Int,
            let price = dict["price"] as? Double
        else {
            return nil
        }

        self.productId = productId
        self.title = title
        self.imageURL = imageURL
        self.quantity = quantity
        self.price = price
    }
}

