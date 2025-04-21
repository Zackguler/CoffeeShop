//
//  HomeViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol HomeViewModelProtocol {
    var isUserLoggedIn: Bool { get }
    func fetchCategories(completion: @escaping ([CoffeeShopItems]) -> Void)
    func fetchCampaigns(completion: @escaping ([Campaign]) -> Void)
    func fetchFavorites(completion: @escaping ([Favorite]) -> Void)
    func addToFavorites(_ product: CoffeeShopItems, completion: @escaping (Result<Void, Error>) -> Void)
    func removeFromFavorites(productId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func isProductFavorited(_ product: CoffeeShopItems) -> Bool
    func toggleFavorite(_ product: CoffeeShopItems, completion: @escaping (Result<Bool, Error>) -> Void)
    func refreshFavorites()
}

final class HomeViewModel: HomeViewModelProtocol {

    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    private let db = Firestore.firestore()
    private(set) var favoriteIDs: Set<String> = []

    func fetchCategories(completion: @escaping ([CoffeeShopItems]) -> Void) {
        FirestoreManager.shared.getCategories { result in
            switch result {
            case .success(let categories):
                completion(categories)
            case .failure:
                completion([])
            }
        }
    }

    func fetchCampaigns(completion: @escaping ([Campaign]) -> Void) {
        db.collection("campaigns").getDocuments { snapshot, _ in
            let items = snapshot?.documents.compactMap { try? $0.data(as: Campaign.self) } ?? []
            completion(items)
        }
    }

    func fetchFavorites(completion: @escaping ([Favorite]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }

        db.collection("users").document(userId).collection("favorites").getDocuments { snapshot, _ in
            let items = snapshot?.documents.compactMap { try? $0.data(as: Favorite.self) } ?? []
            self.favoriteIDs = Set(items.map { $0.productId })
            completion(items)
        }
    }

    func addToFavorites(_ product: CoffeeShopItems, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Giriş yapmanız gerekiyor."])))
            return
        }

        FirestoreManager.shared.addToFavorites(product: product, userId: userId) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.favoriteIDs.insert(product.productId)
                completion(.success(()))
            }
        }
    }

    func isProductFavorited(_ product: CoffeeShopItems) -> Bool {
        return favoriteIDs.contains(product.productId)
    }

    func toggleFavorite(_ product: CoffeeShopItems, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Giriş yapmanız gerekiyor."])))
            return
        }

        let docRef = db.collection("users").document(userId).collection("favorites").document(product.productId)

        docRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if snapshot?.exists == true {
                docRef.delete { err in
                    if let err = err {
                        completion(.failure(err))
                    } else {
                        self.favoriteIDs.remove(product.productId)
                        completion(.success(false))
                    }
                }
            } else {
                let data: [String: Any] = [
                    "product_id": product.productId,
                    "title": product.title,
                    "price": product.price,
                    "image_url": product.imageURL,
                    "type": product.type,
                    "description": product.description,
                    "added_at": FieldValue.serverTimestamp()
                ]
                docRef.setData(data) { err in
                    if let err = err {
                        completion(.failure(err))
                    } else {
                        self.favoriteIDs.insert(product.productId)
                        completion(.success(true))
                    }
                }
            }
        }
    }

    func refreshFavorites() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userId).collection("favorites").getDocuments { snapshot, _ in
            let ids = snapshot?.documents.compactMap { $0.documentID } ?? []
            self.favoriteIDs = Set(ids)
        }
    }
    
    func removeFromFavorites(productId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Auth", code: 401, userInfo: nil)))
            return
        }

        db.collection("users").document(userId).collection("favorites").document(productId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.favoriteIDs.remove(productId)
                completion(.success(()))
            }
        }
    }
}
