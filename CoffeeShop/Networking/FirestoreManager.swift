//
//  FirestoreManager.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//


import FirebaseFirestore

final class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func createUser(userId: String, firstName: String, lastName: String, email: String, completion: @escaping (Error?) -> Void) {
        let userData: [String: Any] = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
        ]
        
        db.collection("users").document(userId).setData(userData, completion: completion)
    }
    
    func getUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = snapshot?.data() else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Veri bulunamadı"])))
                return
            }
            
            do {
                let user = try Firestore.Decoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func deleteUser(userId: String, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userId).delete(completion: completion)
    }
    
    func getCategories(completion: @escaping (Result<[CoffeeShopItems], Error>) -> Void) {
        db.collection("categories").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "Veri yok"])))
                return
            }

            let categories: [CoffeeShopItems] = documents.compactMap { document in
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    let decoded = try JSONDecoder().decode(CoffeeShopItems.self, from: jsonData)
                    return decoded
                } catch {
                    return nil
                }
            }

            completion(.success(categories))
        }
    }
    
    func addToFavorites(product: CoffeeShopItems, userId: String, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "product_id": product.id,
            "title": product.title,
            "price": product.price,
            "image_url": product.imageURL,
            "type": product.type,
            "description": product.description,
            "added_at": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(userId).collection("favorites").document(product.id).setData(data, completion: completion)
    }
}
