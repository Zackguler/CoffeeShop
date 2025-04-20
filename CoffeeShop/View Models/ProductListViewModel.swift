//
//  ProductListViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol ProductListViewModelProtocol {
    var products: [CoffeeShopItems] { get }
    var isUserLoggedIn: Bool { get }
    func loadProducts(completion: @escaping () -> Void)
    func applyFilter(categories: [String], sortAscending: Bool?)
    func searchProducts(by searchText: String)
    func isFavorited(_ product: CoffeeShopItems) -> Bool
}

final class ProductListViewModel: ProductListViewModelProtocol {
    
    private var allProducts: [CoffeeShopItems] = []
    private var filteredProducts: [CoffeeShopItems] = []
    private(set) var products: [CoffeeShopItems] = []
    private var favoriteIds: Set<String> = []
    
    private let db = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    func loadProducts(completion: @escaping () -> Void) {
        Firestore.firestore().collection("categories").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Firestore error: \(error?.localizedDescription ?? "Unknown")")
                completion()
                return
            }
            
            self.allProducts = documents.compactMap { doc -> CoffeeShopItems? in
                let data = doc.data()
                guard
                    let title = data["title"] as? String,
                    let price = data["price"] as? Double,
                    let type = data["type"] as? String,
                    let imageUrl = data["image_url"] as? String,
                    let description = data["description"] as? String
                else {
                    return nil
                }
                
                return CoffeeShopItems(
                    id: doc.documentID,
                    title: title,
                    type: type,
                    imageURL: imageUrl,
                    price: price,
                    description: description
                )
            }
            
            self.loadFavorites {
                self.filteredProducts = self.allProducts
                self.products = self.filteredProducts
                completion()
            }
        }
    }
    
    func loadFavorites(completion: @escaping () -> Void) {
        guard let userId else {
            completion()
            return
        }
        
        db.collection("users").document(userId)
            .collection("favorites").getDocuments { snapshot, error in
                guard let docs = snapshot?.documents, error == nil else {
                    completion()
                    return
                }
                
                self.favoriteIds = Set(docs.map { $0.documentID })
                completion()
            }
    }

    func applyFilter(categories: [String], sortAscending: Bool?) {
        filteredProducts = allProducts.filter { product in
            categories.isEmpty || categories.contains(product.type)
        }
        
        if let sort = sortAscending {
            filteredProducts.sort {
                sort ? $0.price < $1.price : $0.price > $1.price
            }
        }
        
        products = filteredProducts
    }
    
    func searchProducts(by searchText: String) {
        if searchText.isEmpty {
            products = filteredProducts
        } else {
            let lowercased = searchText.lowercased()
            products = filteredProducts.filter {
                $0.title.lowercased().contains(lowercased)
            }
        }
    }
    
    func isFavorited(_ product: CoffeeShopItems) -> Bool {
        return favoriteIds.contains(product.id)
    }
}
