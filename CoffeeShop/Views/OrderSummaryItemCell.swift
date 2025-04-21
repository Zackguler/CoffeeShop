//
//  OrderSummaryItemCell.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit
import SnapKit
import Kingfisher

final class OrderSummaryItemCell: UITableViewCell {
    static let identifier = "OrderSummaryItemCell"

    private let titleLabel = UILabel()
    private let totalLabel = UILabel()
    private let quantityLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = Colors().colorMidBlack
        [titleLabel, totalLabel, quantityLabel].forEach { contentView.addSubview($0) }

        titleLabel.font = UIFont.fontRegular16
        totalLabel.font = UIFont.fontBold16
        quantityLabel.font = UIFont.fontRegular14
        quantityLabel.textColor = .gray

        titleLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(16)
        }

        quantityLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(12)
        }

        totalLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
    }

    func configure(with item: CartItem) {
        titleLabel.text = item.title
        let priceText = String(format: "%.2f", item.price)
        quantityLabel.text = String(format: "order_summary_quantity_price".localized, item.quantity, priceText)

        let total = Double(item.quantity) * item.price
        totalLabel.text = "\(String(format: "%.2f", total))₺"
    }
}
