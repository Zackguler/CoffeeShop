//
//  LoginViewModel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import Foundation

protocol LoginViewModelProtocol {
    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class LoginViewModel: LoginViewModelProtocol {
    private let authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.login(email: email, password: password, completion: completion)
    }
}
