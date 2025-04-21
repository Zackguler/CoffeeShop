//
//  ProductListViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import SnapKit

final class ProductListViewController: UIViewController {

    private let viewModel: ProductListViewModelProtocol
    
    private var debounceTimer: Timer?

    private let searchBarContainer: UIView = {
        let view = UIView()
        return view
    }()

    private let searchTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = "Ürün ara"
        let placeholderColor = Colors().colorDarkGray.withAlphaComponent(0.6)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: UIFont.fontRegular16
            ]
        )
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors().colorFilterBackground
        textField.font = UIFont.fontRegular16
        textField.textColor = Colors().colorDarkGray

        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .gray
        icon.contentMode = .scaleAspectFit
        icon.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 24))
        containerView.addSubview(icon)
        icon.center = containerView.center

        textField.leftView = containerView
        textField.leftViewMode = .always

        return textField
    }()

    private let filterIconButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .medium)
        button.setImage(UIImage(systemName: "slider.horizontal.3", withConfiguration: config), for: .normal)
        button.tintColor = Colors().colorRed
        return button
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        return collectionView
    }()

    init(viewModel: ProductListViewModelProtocol = ProductListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ürünler"
        view.backgroundColor = .white
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        debounceTimer?.invalidate()
    }

    private func setupUI() {
        view.addSubview(searchBarContainer)
        view.addSubview(collectionView)
        searchBarContainer.addSubview(searchTextField)
        searchBarContainer.addSubview(filterIconButton)
        layout()
        collectionView.delegate = self
        collectionView.dataSource = self

        filterIconButton.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func fetchData() {
        LoadingManager.shared.show(in: view)
        viewModel.loadProducts { [weak self] in
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
                self?.collectionView.reloadData()
            }
        }
    }

    @objc private func openFilter() {
        let filterVC = FilterViewController()
        filterVC.delegate = self
        present(filterVC, animated: true)
    }

    @objc private func searchTextChanged(_ textField: UITextField) {
        debounceTimer?.invalidate()
        let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        LoadingManager.shared.show(in: view)
        collectionView.isHidden = true

        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            guard let self = self else { return }

            self.viewModel.searchProducts(by: searchText)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
                LoadingManager.shared.hide()
            }
        }
    }

    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = viewModel.products[indexPath.item]
        let isFavorite = viewModel.isFavorited(product)
        cell.configure(with: product, isFavorite: isFavorite)
        cell.favoriteButton.isHidden = true
        cell.imageView.snp.remakeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 * 3
        let availableWidth = view.frame.width - padding
        let width = availableWidth / 2
        return CGSize(width: width, height: 220)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.item]
        let detailViewModel = ProductDetailViewModel(product: product)
        let detailVC = ProductDetailViewController(viewModel: detailViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ProductListViewController: FilterViewControllerDelegate {
    func didApplyFilter(categories: [String], sortAscending: Bool?) {
        LoadingManager.shared.show(in: view)
        collectionView.isHidden = true
        viewModel.applyFilter(categories: categories, sortAscending: sortAscending)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
            self.collectionView.isHidden = false
            LoadingManager.shared.hide()
        }
    }
}

extension ProductListViewController {
    private func layout() {
        searchBarContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }

        searchTextField.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.right.equalTo(filterIconButton.snp.left).offset(-8)
        }

        filterIconButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
            $0.right.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarContainer.snp.bottom).offset(8)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
