//
//  ForgetPasswordViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//


import Foundation
import FirebaseAuth

protocol ForgetPasswordViewModelProtocol {
    func sendReset(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class ForgetPasswordViewModel: ForgetPasswordViewModelProtocol {
    func sendReset(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }
}
