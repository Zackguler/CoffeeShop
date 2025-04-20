//
//  UILabel + Extensions.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//
import UIKit

extension UILabel {
    func setDoubleFont(text1:String, font1:UIFont, color1: UIColor,text2:String, font2:UIFont, color2: UIColor) {
        let attrs1 = [NSAttributedString.Key.font : font1, NSAttributedString.Key.foregroundColor : color1]
        
        let attrs2 = [NSAttributedString.Key.font : font2,
                      NSAttributedString.Key.foregroundColor : color2,
                      NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        
        let attributedString1 = NSMutableAttributedString(string:text1, attributes:attrs1)
        
        let attributedString2 = NSMutableAttributedString(string:text2, attributes:attrs2)
        
        attributedString1.append(attributedString2)
        
        self.attributedText = attributedString1
    }
}

extension NSMutableAttributedString {

    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)

        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: UIFont.fontBold14, range: range)
    }

}
