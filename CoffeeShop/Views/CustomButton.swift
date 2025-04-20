//
//  CustomButton.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit

class CustomButton: UIButton {

    private var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(frame: .zero)
        backgroundColor = Colors().colorRed
        titleLabel?.font = UIFont.fontBold16
        setTitleColor(.white, for: .normal)
        setCornerRound(value: 8.0)
        self.addTarget(self, action: #selector(execute), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func execute() {
        action()
    }
}
