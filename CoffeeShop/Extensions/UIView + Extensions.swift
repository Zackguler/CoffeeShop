//
//  UIView + Extensions.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit

extension UIView {
    func setBorder(width:CGFloat, color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func setCornerRound(value:CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = value
    }
}
