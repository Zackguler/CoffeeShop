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
}
