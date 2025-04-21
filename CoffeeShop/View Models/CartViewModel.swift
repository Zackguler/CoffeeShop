//
//  CartViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol CartViewModelProtocol {
    var cartItems: [CartItem] { get }
    var totalPrice: Double { get }
    var isUserLoggedIn: Bool { get }
    func increaseQuantity(for item: CartItem)
    func decreaseQuantity(for item: CartItem)
    func placeOrder(completion: @escaping (Bool) -> Void)
    func loadCart(completion: @escaping () -> Void)
    func saveOrderToHistory(orderId: String, date: Date, items: [CartItem])
}

final class CartViewModel: CartViewModelProtocol {

    private(set) var cartItems: [CartItem] = []
    private let db = Firestore.firestore()
    private var userId: String? { Auth.auth().currentUser?.uid }

    var isUserLoggedIn: Bool { userId != nil }

    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    func loadCart(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            self.cartItems = []
            completion()
            return
        }

        db.collection("users").document(userId).collection("cart").getDocuments { snapshot, error in
            if let error = error {
                print("Sepet çekilemedi:", error.localizedDescription)
                completion()
                return
            }

            let docs = snapshot?.documents ?? []

            self.cartItems = docs.compactMap { doc in
                return CartItem(from: doc.data())
            }
            completion()
        }
    }

    func increaseQuantity(for item: CartItem) {
        updateQuantity(for: item, delta: 1)
    }

    func decreaseQuantity(for item: CartItem) {
        updateQuantity(for: item, delta: -1)
    }

    private func updateQuantity(for item: CartItem, delta: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let index = cartItems.firstIndex(where: { $0.productId == item.productId }) else { return }

        var updatedItem = cartItems[index]
        updatedItem.quantity += delta
        if updatedItem.quantity <= 0 {
            db.collection("users").document(userId)
                .collection("cart").document(item.productId)
                .delete { [weak self] error in
                    if let error = error {
                        print("Firestore silme hatası:", error.localizedDescription)
                    } else {
                        print("Ürün sepetten silindi: \(item.title)")
                        self?.cartItems.remove(at: index)
                    }
                }
            return
        }
        cartItems[index] = updatedItem

        do {
            try db.collection("users").document(userId)
                .collection("cart").document(item.productId)
                .setData(from: updatedItem)
        } catch {
            print("🔥 setData hatası:", error.localizedDescription)
        }
    }


    func placeOrder(completion: @escaping (Bool) -> Void) {
        guard let userId else {
            completion(false)
            return
        }

        let orderData: [String: Any] = [
            "user_id": userId,
            "total_price": totalPrice,
            "date": Timestamp(date: Date()),
            "items": cartItems.map { [
                "title": $0.title,
                "price": $0.price,
                "quantity": $0.quantity,
                "image_url": $0.imageURL
            ]}
        ]

        db.collection("orders").addDocument(data: orderData) { error in
            if let error = error {
                print("Sipariş oluşturulamadı:", error.localizedDescription)
                completion(false)
            } else {
                let batch = self.db.batch()
                self.cartItems.forEach { item in
                    let ref = self.db.collection("users").document(userId).collection("cart").document(item.productId)
                    batch.deleteDocument(ref)
                }
                batch.commit { _ in
                    self.cartItems.removeAll()
                    completion(true)
                }
            }
        }
    }
    
    func saveOrderToHistory(orderId: String, date: Date, items: [CartItem]) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let orderData: [String: Any] = [
            "order_id": orderId,
            "order_date": Timestamp(date: date),
            "total_price": items.reduce(0) { $0 + Double($1.quantity) * $1.price },
            "items": items.map { item in
                return [
                    "productId": item.productId,
                    "title": item.title,
                    "price": item.price,
                    "quantity": item.quantity,
                    "image_url": item.imageURL,
                ]
            }
        ]

        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("past_orders")
            .document(orderId)
            .setData(orderData) { error in
                if let error = error {
                    print("Sipariş geçmişi kayıt hatası:", error.localizedDescription)
                } else {
                    print("Sipariş geçmişine kaydedildi.")
                }
            }
    }
}
