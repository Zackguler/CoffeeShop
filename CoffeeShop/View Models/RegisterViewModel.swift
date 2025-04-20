//
//  RegisterViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import FirebaseAuth
import FirebaseFirestore

protocol RegisterViewModelProtocol {
    func register(firstName: String,
                  lastName: String,
                  email: String,
                  password: String,
                  completion: @escaping (Result<Void, Error>) -> Void)
}

final class RegisterViewModel: RegisterViewModelProtocol {
    private let authService: AuthServiceProtocol
    private let firestore = Firestore.firestore()

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func register(firstName: String,
                 lastName: String,
                 email: String,
                 password: String,
                 completion: @escaping (Result<Void, Error>) -> Void) {
        
        authService.register(email: email, password: password) { result in
            switch result {
            case .success(let authDataResult):
                FirestoreManager.shared.createUser(
                    userId: authDataResult.user.uid,
                    firstName: firstName,
                    lastName: lastName,
                    email: email
                ) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func updateUserProfileAndSaveToFirestore(authDataResult: AuthDataResult,
                                                   firstName: String,
                                                   lastName: String,
                                                   email: String,
                                                   completion: @escaping (Result<Void, Error>) -> Void) {
        let changeRequest = authDataResult.user.createProfileChangeRequest()
        changeRequest.displayName = "\(firstName) \(lastName)"
        
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        firestore.collection("users").document(authDataResult.user.uid).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            changeRequest.commitChanges { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
