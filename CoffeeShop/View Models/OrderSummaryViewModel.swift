//
//  OrderSummaryViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import Foundation

protocol OrderSummaryViewModelProtocol {
    var orderDate: Date { get }
    var orderId: String { get }
    var items: [CartItem] { get }
    var totalPrice: Double { get }
}

final class OrderSummaryViewModel: OrderSummaryViewModelProtocol {
    let orderDate: Date
    let orderId: String
    let items: [CartItem]
    let totalPrice: Double

    init(orderDate: Date, orderId: String = UUID().uuidString.prefix(6).description, items: [CartItem]) {
        self.orderDate = orderDate
        self.orderId = orderId
        self.items = items
        self.totalPrice = items.reduce(0) { $0 + (Double($1.quantity) * $1.price) }
    }
}
