//
//  OrderHistoryViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//
import FirebaseAuth
import FirebaseFirestore

protocol OrderHistoryViewModelProtocol {
    var groupedOrders: [OrderGroup] { get }
    func fetchOrders(completion: @escaping () -> Void)
}

struct OrderGroup {
    let date: Date
    let orders: [PastOrder]
}

final class OrderHistoryViewModel: OrderHistoryViewModelProtocol {
    private(set) var groupedOrders: [OrderGroup] = []

    func fetchOrders(completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion()
            return
        }

        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("past_orders")
            .order(by: "order_date", descending: true)
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents, error == nil else {
                    print("Siparişler alınamadı:", error?.localizedDescription ?? "")
                    completion()
                    return
                }

                let orders = docs.compactMap { PastOrder(from: $0.data()) }
                let grouped = Dictionary(grouping: orders) { order in
                    Calendar.current.startOfDay(for: order.orderDate)
                }

                self.groupedOrders = grouped
                    .map { OrderGroup(date: $0.key, orders: $0.value) }
                    .sorted { $0.date > $1.date }

                completion()
            }
    }
}
