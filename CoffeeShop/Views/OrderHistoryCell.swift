//
//  OrderHistoryCell.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit

final class OrderHistoryCell: UITableViewCell {

    private let orderIdLabel = UILabel()
    private let summaryLabel = UILabel()
    private let timeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = Colors().colorLightGray
        [orderIdLabel, summaryLabel, timeLabel].forEach { contentView.addSubview($0) }

        orderIdLabel.font = .fontBold16
        orderIdLabel.textColor = Colors().colorDarkGray

        summaryLabel.font = .fontRegular14
        summaryLabel.textColor = .gray

        timeLabel.font = .fontRegular14
        timeLabel.textColor = .gray
        timeLabel.textAlignment = .right

        orderIdLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(16)
        }

        summaryLabel.snp.makeConstraints {
            $0.top.equalTo(orderIdLabel.snp.bottom).offset(4)
            $0.left.equalTo(orderIdLabel)
            $0.bottom.equalToSuperview().inset(12)
        }

        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(orderIdLabel)
            $0.right.equalToSuperview().inset(16)
        }
    }

    func configure(with order: PastOrder) {
        let formattedPrice = String(format: "%.2f", order.totalPrice)
        orderIdLabel.text = String(format: "order_id_format".localized, order.orderId)
        summaryLabel.text = String(format: "order_summary_format".localized, order.items.count, formattedPrice)

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeLabel.text = formatter.string(from: order.orderDate)
    }
}
