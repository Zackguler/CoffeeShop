//
//  CampaignSliderCell.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import SnapKit

final class CampaignSliderCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = Colors().colorRed

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        titleLabel.font = UIFont.fontBold12
        titleLabel.textColor = Colors().colorWhite
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2

        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)

        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(180)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview().inset(12)
        }
    }

    func configure(with model: Campaign) {
        imageView.setImage(urlString: model.imageURL)
        titleLabel.text = model.title
    }
}


