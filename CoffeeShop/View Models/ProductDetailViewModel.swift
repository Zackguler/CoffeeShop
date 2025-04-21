//
//  ProductDetailViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol ProductDetailViewModelProtocol {
    var product: CoffeeShopItems { get }
    var isFavorited: Bool { get }
    var favoriteStatusChanged: ((Bool) -> Void)? { get set }
    
    func toggleFavorite(completion: @escaping (Bool) -> Void)
    func addToCart(quantity: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ProductDetailViewModel: ProductDetailViewModelProtocol {
    let product: CoffeeShopItems
    private(set) var isFavorited: Bool = false {
        didSet {
            favoriteStatusChanged?(isFavorited)
        }
    }
    
    var favoriteStatusChanged: ((Bool) -> Void)?
    
    private let db = Firestore.firestore()
    private let userId = Auth.auth().currentUser?.uid ?? ""
    
    init(product: CoffeeShopItems) {
        self.product = product
        fetchFavoriteStatus()
    }
    
    private func fetchFavoriteStatus() {
        guard !userId.isEmpty else { return }
        db.collection("users").document(userId)
            .collection("favorites")
            .document(product.productId)
            .getDocument { snapshot, _ in
                self.isFavorited = snapshot?.exists ?? false
            }
    }
    
    func toggleFavorite(completion: @escaping (Bool) -> Void) {
        guard !userId.isEmpty else { return }
        let ref = db.collection("users").document(userId)
            .collection("favorites").document(product.productId)

        if isFavorited {
            ref.delete { error in
                if error == nil {
                    self.isFavorited = false
                    completion(false)
                    NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
                }
            }
        } else {
            let data: [String: Any] = [
                "product_id": product.productId,
                "title": product.title,
                "image_url": product.imageURL,
                "price": product.price,
                "type": product.type,
                "description": product.description,
                "added_at": FieldValue.serverTimestamp()
            ]

            ref.setData(data) { error in
                if error == nil {
                    self.isFavorited = true
                    completion(true)
                    NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
                }
            }
        }
    }


    
    func addToCart(quantity: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !userId.isEmpty else {
            completion(.failure(NSError(
                domain: "Auth",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey: "product_detail_login_required".localized]
            )))
            return
        }

        let cartRef = db.collection("users").document(userId).collection("cart").document(product.productId)

        cartRef.getDocument { snapshot, error in
            var existingQuantity = 0
            if let data = snapshot?.data(), let q = data["quantity"] as? Int {
                existingQuantity = q
            }

            let newQuantity = existingQuantity + quantity

            let data: [String: Any] = [
                "productId": self.product.productId,
                "title": self.product.title,
                "image_url": self.product.imageURL,
                "price": self.product.price,
                "quantity": newQuantity,
                "type": self.product.type
            ]

            cartRef.setData(data, merge: true) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }

}
