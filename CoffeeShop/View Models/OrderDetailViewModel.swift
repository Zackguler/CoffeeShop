//
//  OrderDetailViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import Foundation

protocol OrderDetailViewModelProtocol {
    var orderId: String { get }
    var orderDate: Date { get }
    var items: [CartItem] { get }
    var totalPrice: Double { get }
}

final class OrderDetailViewModel: OrderDetailViewModelProtocol {
    let orderId: String
    let orderDate: Date
    let items: [CartItem]

    var totalPrice: Double {
        items.reduce(0) { $0 + (Double($1.quantity) * $1.price) }
    }

    init(order: PastOrder) {
        self.orderId = order.orderId
        self.orderDate = order.orderDate
        self.items = order.items
    }
}
