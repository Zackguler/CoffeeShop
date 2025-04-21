//
//  UIViewController + Extensions.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showAlert(title: String, error: Error) {
        showAlert(title: title, message: error.localizedDescription)
    }
}

