//
//  PastOrder.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import Foundation
import FirebaseFirestore

struct PastOrder {
    let orderId: String
    let orderDate: Date
    let totalPrice: Double
    let items: [CartItem]

    init?(from data: [String: Any]) {
        guard
            let orderId = data["order_id"] as? String,
            let timestamp = data["order_date"] as? Timestamp,
            let totalPrice = data["total_price"] as? Double,
            let rawItems = data["items"] as? [[String: Any]]
        else {
            return nil
        }

        self.orderId = orderId
        self.orderDate = timestamp.dateValue()
        self.totalPrice = totalPrice
        self.items = rawItems.compactMap { CartItem(from: $0) }
    }
}
