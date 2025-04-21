//
//  HomeViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModelProtocol
    let scrollView = UIScrollView()
    private let stackView = UIStackView()

    private let campaignSliderView = CampaignsSliderView()

    private lazy var hotCategoryView = makeCategorySectionView(with: "hot_drinks_title".localized)
    private lazy var coldCategoryView = makeCategorySectionView(with: "cold_drinks_title".localized)
    private lazy var foodCategoryView = makeCategorySectionView(with: "food_title".localized)

    private var favoriteProductView: TitledCollectionView<Favorite, ProductCell>!

    init(viewModel: HomeViewModelProtocol = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if viewModel.isUserLoggedIn && !stackView.arrangedSubviews.contains(favoriteProductView) {
            stackView.addArrangedSubview(favoriteProductView)
        }
        fetchData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().colorWhite

        scrollView.isHidden = true
        LoadingManager.shared.show(in: view)

        setupFavoritesSection()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites), name: .favoritesUpdated, object: nil)
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalTo(scrollView.snp.width).offset(-32)
        }

        stackView.addArrangedSubview(campaignSliderView)
        campaignSliderView.snp.makeConstraints { $0.height.equalTo(250) }
        stackView.addArrangedSubview(hotCategoryView)
        stackView.addArrangedSubview(coldCategoryView)
        stackView.addArrangedSubview(foodCategoryView)

        if viewModel.isUserLoggedIn {
            stackView.addArrangedSubview(favoriteProductView)
        }
    }

    private func fetchData() {
        let group = DispatchGroup()

        group.enter()
        viewModel.fetchCampaigns { [weak self] campaigns in
            DispatchQueue.main.async {
                self?.campaignSliderView.update(with: campaigns)
                group.leave()
            }
        }

        group.enter()
        viewModel.fetchCategories { [weak self] categories in
            DispatchQueue.main.async {
                self?.hotCategoryView.update(with: categories.filter { $0.type == "hot" })
                self?.coldCategoryView.update(with: categories.filter { $0.type == "cold" })
                self?.foodCategoryView.update(with: categories.filter { $0.type == "food" })
                group.leave()
            }
        }

        if viewModel.isUserLoggedIn {
            group.enter()
            viewModel.fetchFavorites { [weak self] favorites in
                DispatchQueue.main.async {
                    self?.favoriteProductView.update(with: favorites)
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            LoadingManager.shared.hide()
            self?.scrollView.isHidden = false
        }
    }

    private func setupFavoritesSection() {
        favoriteProductView = TitledCollectionView<Favorite, ProductCell>(
            title: "favorite_products_title".localized,
            cellType: ProductCell.self
        ) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return ProductCell() }

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ProductCell.self),
                for: indexPath
            ) as! ProductCell

            cell.configure(with: item)

            cell.onFavoriteTapped = {
                self.viewModel.removeFromFavorites(productId: item.productId) { result in
                    switch result {
                    case .success:
                        self.viewModel.fetchFavorites { updatedFavorites in
                            DispatchQueue.main.async {
                                self.favoriteProductView.update(with: updatedFavorites)
                                self.refreshCategorySections()
                            }
                        }
                    case .failure(let error):
                        print("Favoriden çıkarma hatası: \(error.localizedDescription)")
                    }
                }
            }

            return cell
        }

        favoriteProductView.onItemSelected = { [weak self] favoriteItem in
            guard let self = self else { return }
            let product = CoffeeShopItems(
                productId: favoriteItem.productId,
                title: favoriteItem.title,
                type: favoriteItem.type,
                imageURL: favoriteItem.imageURL,
                price: favoriteItem.price,
                description: favoriteItem.description
            )
            let detailViewModel = ProductDetailViewModel(product: product)
            let detailVC = ProductDetailViewController(viewModel: detailViewModel)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    @objc private func refreshFavorites() {
        guard viewModel.isUserLoggedIn else { return }

        viewModel.fetchFavorites { [weak self] favorites in
            DispatchQueue.main.async {
                self?.favoriteProductView.update(with: favorites)
                self?.refreshCategorySections()
            }
        }
    }

    private func refreshCategorySections() {
        viewModel.fetchCategories { [weak self] categories in
            DispatchQueue.main.async {
                self?.hotCategoryView.update(with: categories.filter { $0.type == "hot" })
                self?.coldCategoryView.update(with: categories.filter { $0.type == "cold" })
                self?.foodCategoryView.update(with: categories.filter { $0.type == "food" })
            }
        }
    }

    private func makeCategorySectionView(with title: String) -> TitledCollectionView<CoffeeShopItems, ProductCell> {
        let section = CategorySectionFactory.makeCategorySection(
            title: title,
            items: [],
            viewModel: viewModel,
            onLoginRequired: { [weak self] in
                self?.showAlert(title: "login_required_title".localized, message: "login_required_message".localized)
            },
            onFavoriteToggled: { [weak self] in
                self?.refreshFavorites()
            }
        )
        section.onItemSelected = { [weak self] product in
            guard let self = self else { return }
            let viewModel = ProductDetailViewModel(product: product)
            let vc = ProductDetailViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        return section
    }
}

struct CategorySectionFactory {
    static func makeCategorySection(
        title: String,
        items: [CoffeeShopItems],
        viewModel: HomeViewModelProtocol,
        onLoginRequired: @escaping () -> Void,
        onFavoriteToggled: (() -> Void)? = nil
    ) -> TitledCollectionView<CoffeeShopItems, ProductCell> {

        return TitledCollectionView<CoffeeShopItems, ProductCell>(
            title: title,
            cellType: ProductCell.self
        ) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductCell.self), for: indexPath) as! ProductCell
            let isFavorite = viewModel.isProductFavorited(item)
            cell.configure(with: item, isFavorite: isFavorite)
            cell.onFavoriteTapped = {
                if !viewModel.isUserLoggedIn {
                    onLoginRequired()
                } else {
                    viewModel.toggleFavorite(item) { result in
                        switch result {
                        case .success(_):
                            DispatchQueue.main.async {
                                collectionView.reloadItems(at: [indexPath])
                                onFavoriteToggled?()
                            }
                        case .failure(let error):
                            print("Hata:", error.localizedDescription)
                        }
                    }
                }
            }
            return cell
        }
    }
}
