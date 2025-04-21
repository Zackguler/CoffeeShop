//
//  CategoryCell.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import SnapKit

final class ProductCell: UICollectionViewCell {

    let imageView = UIImageView()
    let titleLabel = UILabel()
    private let priceButton = CustomButton(action: {})
    let favoriteButton = UIButton(type: .system)

    var onFavoriteTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceButton)
        contentView.addSubview(favoriteButton)

        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = Colors().colorBorderLight.cgColor
        contentView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.font = .fontBold14
        titleLabel.textColor = Colors().colorDarkGray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        priceButton.titleLabel?.font = .fontBold10
        priceButton.isUserInteractionEnabled = false
        priceButton.setTitleColor(Colors().colorWhite, for: .normal)

        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = Colors().colorRed
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }

        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.right.equalToSuperview().inset(4)
            make.width.height.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.left.right.equalToSuperview().inset(4)
        }

        priceButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
            make.height.equalTo(28)
        }
    }

    @objc private func favoriteTapped() {
        onFavoriteTapped?()
    }

    func configure(with category: CoffeeShopItems, isFavorite: Bool = false) {
        titleLabel.text = category.title
        imageView.setImage(urlString: category.imageURL)
        priceButton.setTitle("₺\(String(format: "%.2f", category.price))", for: .normal)

        let starImage = UIImage(systemName: isFavorite ? "star.fill" : "star")
        favoriteButton.setImage(starImage, for: .normal)
    }

    func configure(with product: Favorite) {
        titleLabel.text = product.title
        imageView.setImage(urlString: product.imageURL)
        priceButton.setTitle("₺\(String(format: "%.2f", product.price))", for: .normal)

        let starImage = UIImage(systemName: "star.fill")
        favoriteButton.setImage(starImage, for: .normal)
    }
}
