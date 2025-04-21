//
//  CartItemCell.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit
import SnapKit
import Kingfisher

final class CartItemCell: UITableViewCell {

    var onIncrease: (() -> Void)?
    var onDecrease: (() -> Void)?

    private let productImageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let quantityLabel = UILabel()
    private let minusButton = UIButton()
    private let plusButton = UIButton()
    private let bottomLine = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = Colors().colorWhite
        [productImageView, titleLabel, priceLabel, minusButton, quantityLabel, plusButton].forEach {
            contentView.addSubview($0)
        }
        productImageView.setCornerRound(value: 8)
        productImageView.snp.makeConstraints {
            $0.size.equalTo(64)
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        titleLabel.font = UIFont.fontRegular16
        titleLabel.textColor = Colors().colorDarkGray
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalTo(productImageView.snp.right).offset(16)
        }

        priceLabel.font = UIFont.fontRegular14
        priceLabel.textColor = Colors().colorDarkGray
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(titleLabel)
        }

        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        [minusButton, plusButton].forEach {
            $0.setTitleColor(.black, for: .normal)
            $0.layer.borderColor = Colors().colorMidBlack.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 12
        }

        minusButton.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }

        quantityLabel.textAlignment = .center
        quantityLabel.textColor = Colors().colorDarkGray
        quantityLabel.snp.makeConstraints {
            $0.left.equalTo(minusButton.snp.right).offset(8)
            $0.centerY.equalTo(minusButton)
            $0.width.equalTo(30)
        }

        plusButton.snp.makeConstraints {
            $0.left.equalTo(quantityLabel.snp.right).offset(8)
            $0.centerY.equalTo(minusButton)
            $0.size.equalTo(24)
        }
        
        bottomLine.backgroundColor = Colors().colorMidBlack.withAlphaComponent(0.2)
        contentView.addSubview(bottomLine)

        bottomLine.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
    }

    func configure(with item: CartItem) {
        titleLabel.text = item.title
        quantityLabel.text = "\(item.quantity)"
        
        let total = Double(item.quantity) * item.price
        priceLabel.text = "\(String(format: "%.2f", total)) ₺"
        productImageView.kf.setImage(with: URL(string: item.imageURL))
    }
    
    func setBottomLineVisible(_ isVisible: Bool) {
        bottomLine.isHidden = !isVisible
    }

    @objc private func didTapMinus() {
        onDecrease?()
    }

    @objc private func didTapPlus() {
        onIncrease?()
    }
}
