//
//  TitledCollectionView.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import SnapKit

final class TitledCollectionView<ItemType, Cell: UICollectionViewCell>: UIView, UICollectionViewDataSource {
    
    private let titleLabel = UILabel()
    private var items: [ItemType] = []
    private let cellProvider: (UICollectionView, IndexPath, ItemType) -> Cell
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Favori ürün bulunmamaktadır."
        label.font = .fontRegular16
        label.textColor = Colors().colorDarkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumLineSpacing = 12

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        return collectionView
    }()

    init(title: String,
         cellType: Cell.Type,
         cellProvider: @escaping (UICollectionView, IndexPath, ItemType) -> Cell)
    {
        self.cellProvider = cellProvider
        super.init(frame: .zero)
        self.titleLabel.text = title
        titleLabel.font = UIFont.fontBold24
        titleLabel.textColor = Colors().colorDarkGray
        collectionView.register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with newItems: [ItemType]) {
        self.items = newItems
        collectionView.reloadData()
        emptyLabel.isHidden = !items.isEmpty
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(collectionView)
        addSubview(emptyLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(180)
        }
        emptyLabel.snp.makeConstraints { make in
            make.edges.equalTo(collectionView).inset(16)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellProvider(collectionView, indexPath, items[indexPath.item])
    }
}
