//
//  UIImageView + Extensions.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        self.kf.setImage(with: url)
    }
}
