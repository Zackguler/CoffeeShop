//
//  ProductDetailViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseAuth

final class ProductDetailViewController: UIViewController {

    private var viewModel: ProductDetailViewModelProtocol

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView = UIImageView()
    private let favoriteButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let bottomBar = UIView()
    private let decrementButton = UIButton(type: .system)
    private let incrementButton = UIButton(type: .system)
    private let quantityValueLabel = UILabel()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = Colors().colorRed
        return button
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Toplam Fiyat"
        label.font = UIFont.fontRegular14
        label.textColor = Colors().colorDarkGray
        return label
    }()
    
    private lazy var addToCartButton: CustomButton = {
        let button = CustomButton {
            self.addToCartTapped()
        }
        button.setTitle("Sepette Ekle", for: .normal)
        return button
    }()

    private var quantity: Int = 1 {
        didSet {
            quantity = max(quantity, 1)
            quantityValueLabel.text = "\(quantity)"
            updatePriceLabel()
        }
    }

    init(viewModel: ProductDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configure()
    }

    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(bottomBar)

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true

        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)

        titleLabel.font = UIFont.fontBold22
        titleLabel.textColor = Colors().colorMidBlack
        titleLabel.numberOfLines = 0

        descriptionLabel.font = UIFont.fontRegular16
        descriptionLabel.textColor = Colors().colorDarkGray
        descriptionLabel.numberOfLines = 0

        priceLabel.font = UIFont.fontBold20
        priceLabel.textColor = Colors().colorRed

        contentView.addSubview(imageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(totalLabel)
        contentView.addSubview(priceLabel)

        bottomBar.backgroundColor = Colors().colorWhite
        [decrementButton, quantityValueLabel, incrementButton, addToCartButton].forEach {
            bottomBar.addSubview($0)
        }

        decrementButton.setTitle("-", for: .normal)
        decrementButton.titleLabel?.font = UIFont.fontBold22
        decrementButton.backgroundColor = Colors().colorWhite
        decrementButton.tintColor = Colors().colorMidBlack
        decrementButton.layer.cornerRadius = 20
        decrementButton.layer.borderWidth = 1
        decrementButton.layer.borderColor = Colors().colorBorderLight.cgColor
        decrementButton.addTarget(self, action: #selector(decrementTapped), for: .touchUpInside)

        incrementButton.setTitle("+", for: .normal)
        incrementButton.titleLabel?.font = UIFont.fontBold22
        incrementButton.backgroundColor = Colors().colorWhite
        incrementButton.tintColor = Colors().colorMidBlack
        incrementButton.layer.cornerRadius = 20
        incrementButton.layer.borderWidth = 1
        incrementButton.layer.borderColor = Colors().colorBorderLight.cgColor
        incrementButton.addTarget(self, action: #selector(incrementTapped), for: .touchUpInside)

        quantityValueLabel.text = "1"
        quantityValueLabel.font = UIFont.fontBold16
        quantityValueLabel.textColor = Colors().colorMidBlack
        quantityValueLabel.textAlignment = .center

        addToCartButton.setTitleColor(.white, for: .normal)
        addToCartButton.layer.cornerRadius = 10
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)

        layout()
    }

    private func configure() {
        imageView.setImage(urlString: viewModel.product.imageURL)
        titleLabel.text = viewModel.product.title
        descriptionLabel.text = viewModel.product.description
        updatePriceLabel()
        updateFavoriteUI()
        viewModel.favoriteStatusChanged = { [weak self] _ in
            self?.updateFavoriteUI()
        }
    }

    private func updatePriceLabel() {
        let total = viewModel.product.price * Double(quantity)
        priceLabel.text = "\(total) TL"
    }

    private func updateFavoriteUI() {
        let imageName = viewModel.isFavorited ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        favoriteButton.tintColor = viewModel.isFavorited ? Colors().colorRed : .lightGray
    }

    @objc private func toggleFavorite() {
        viewModel.toggleFavorite { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateFavoriteUI()
                NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
            }
        }
    }

    @objc private func decrementTapped() {
        quantity -= 1
    }

    @objc private func incrementTapped() {
        quantity += 1
    }

    @objc private func addToCartTapped() {
        viewModel.addToCart(quantity: quantity) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.showAlert(title: "Başarılı", message: "Ürün sepete eklendi.")
                case .failure(let error):
                    self?.showAlert(title: "Hata", message: error.localizedDescription)
                }
            }
        }
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProductDetailViewController {
    private func layout() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(32)
        }

        bottomBar.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomBar.snp.top)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(220)
        }

        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top).offset(12)
            $0.right.equalTo(imageView.snp.right).inset(12)
            $0.width.height.equalTo(30)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
        }

        totalLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
        }

        priceLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalTo(totalLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(16)
        }

        decrementButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        quantityValueLabel.snp.makeConstraints {
            $0.left.equalTo(decrementButton.snp.right).offset(8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(30)
        }

        incrementButton.snp.makeConstraints {
            $0.left.equalTo(quantityValueLabel.snp.right).offset(8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        addToCartButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(48)
            $0.width.equalToSuperview().multipliedBy(0.45)
        }
    }
}
