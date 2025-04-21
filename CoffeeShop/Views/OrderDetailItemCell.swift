//
//  OrderDetailItemCell.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit
import SnapKit

final class OrderDetailItemCell: UITableViewCell {
    static let identifier = "OrderDetailItemCell"

    private let titleLabel = UILabel()
    private let quantityLabel = UILabel()
    private let priceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = Colors().colorWhite
        [titleLabel, quantityLabel, priceLabel].forEach { contentView.addSubview($0) }

        titleLabel.font = .fontRegular16
        titleLabel.textColor = Colors().colorDarkGray

        quantityLabel.font = .fontRegular14
        quantityLabel.textColor = .gray

        priceLabel.font = .fontRegular16
        priceLabel.textColor = Colors().colorDarkGray
        priceLabel.textAlignment = .right

        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }

        quantityLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(12)
        }

        priceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
    }

    func configure(with item: CartItem) {
        titleLabel.text = item.title
        quantityLabel.text = "\(item.quantity) adet x \(String(format: "%.2f", item.price))₺"
        let total = Double(item.quantity) * item.price
        priceLabel.text = "\(String(format: "%.2f", total))₺"
    }
}
