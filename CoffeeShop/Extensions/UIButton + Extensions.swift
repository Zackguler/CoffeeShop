//
//  UIButton + Extensions.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//
import UIKit

extension UIButton {
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        self.adjustsImageWhenHighlighted = false
        self.isHighlighted = false
        self.isSelected = !isSelected
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}
