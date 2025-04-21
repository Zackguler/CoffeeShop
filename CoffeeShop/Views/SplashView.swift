//
//  SplashView.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import UIKit
import SnapKit

final class SplashView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("coffeeshop.title", comment: "")
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = Colors().colorRed
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Colors().colorWhite
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
    }
}
