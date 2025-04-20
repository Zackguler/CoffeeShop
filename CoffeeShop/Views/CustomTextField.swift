//
//  CustomTextField.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import UIKit
import SnapKit

final class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.setBorder(width: 1.0, color: Colors().colorBorderLight)
        self.setCornerRound(value: 10.0)
        self.fontt = UIFont.fontRegular16
        self.colorr = Colors().colorDarkGray
        self.addDoneButtonOnKeyboard()
        self.setLeftPaddingPoints(14.0)
    }
    
    var fontt : UIFont = UIFont.fontBold16 {
        didSet {
            self.setFont()
        }
    }
    private func setFont() {
        self.font = fontt
    }
    
    var colorr : UIColor = Colors().colorDarkGray {
        didSet {
            self.setTextColor()
        }
    }
    private func setTextColor() {
        self.textColor = colorr
    }
}
