//
//  ProfileViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import Foundation
import FirebaseAuth

protocol ProfileViewModelProtocol {
    var userID: String? { get }
    var userEmail: String? { get }
    var isLoggedIn: Bool { get }
    
    func fetchUser(completion: @escaping (User) -> Void)
    func logout(completion: @escaping (Error?) -> Void)
    func deleteAccount(password: String, completion: @escaping (Error?) -> Void)

}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    var userID: String? {
        return Auth.auth().currentUser?.uid
    }

    var userEmail: String? {
        return Auth.auth().currentUser?.email
    }
    
    var isLoggedIn: Bool {
        return userID != nil
    }

    func fetchUser(completion: @escaping (User) -> Void) {
        guard let userID = userID else { return }
        
        FirestoreManager.shared.getUser(userId: userID) { result in
            switch result {
            case .success(let user):
                completion(user)
            case .failure(let error):
                self.logout() {_ in }
                print("Kullanıcı verisi alınamadı:", error.localizedDescription)
            }
        }
    }

    func logout(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }

    func deleteAccount(password: String, completion: @escaping (Error?) -> Void) {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            completion(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı bulunamadı"]))
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(error)
                return
            }

            let userId = user.uid
            FirestoreManager.shared.deleteUser(userId: userId) { error in
                if let error = error {
                    completion(error)
                    return
                }

                user.delete { error in
                    completion(error)
                }
            }
        }
    }

}
