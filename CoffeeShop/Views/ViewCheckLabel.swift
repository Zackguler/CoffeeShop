//
//  ViewCheckLabel.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//


import UIKit

class ViewCheckLabel: UIView {

    private var action: () -> Void
    public let buttonCheck : UIButton
    let labelText : UILabel

    init(text:String, range:String, action: @escaping () -> Void) {
        self.action = action
        
        buttonCheck = UIButton()
        buttonCheck.setImage(UIImage.init(named: "checked_none"), for: .normal)
        buttonCheck.setImage(UIImage.init(named: "checked"), for: .selected)
        
        self.labelText = UILabel()
        self.labelText.textAlignment = .left
        self.labelText.numberOfLines = 0
        self.labelText.font = UIFont.fontRegular14
        
        if !range.isEmpty {
            if let rangeOfString = text.range(of: range) {
                let startPos = text.distance(from: text.startIndex, to: rangeOfString.lowerBound)
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
                attributedString.setColorForText(textForAttribute: range, withColor: Colors().colorDarkGray)
                attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: NSRange.init(location: startPos, length: range.count))
                self.labelText.attributedText = attributedString
            }
        } else {
            self.labelText.text = text
        }
        super.init(frame: CGRect.zero)
        self.buttonCheck.addTarget(self, action: #selector(execute(_:)), for: .touchUpInside)
        self.inputView()
        self.setupConstraints()
    }
    
    private func inputView() {
        backgroundColor = .white
        addSubview(buttonCheck)
        addSubview(labelText)
    }
    
    private func setupConstraints() {
        labelText.snp.makeConstraints { make in
            make.leading.equalTo(32)
            make.trailing.equalTo(0)
            make.top.equalTo(0)
        }
        buttonCheck.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.height.width.equalTo(25)
            make.centerY.equalTo(labelText.snp.centerY)
        }
        
    }
    
    @objc private func execute(_ sender : UIButton) {
        action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not implemented")
    }
}
