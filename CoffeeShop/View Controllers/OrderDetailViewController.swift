//
//  OrderDetailViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit
import SnapKit

final class OrderDetailViewController: UIViewController {

    private let viewModel: OrderDetailViewModelProtocol
    private let tableView = UITableView()
    private let headerLabel = UILabel()
    private let dateLabel = UILabel()
    private let totalLabel = UILabel()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = Colors().colorRed
        return button
    }()

    init(viewModel: OrderDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "order_detail_title".localized
        view.backgroundColor = Colors().colorWhite
        setupUI()
    }

    private func setupUI() {
        headerLabel.text = "order_number_prefix".localized + "\(viewModel.orderId)"
        headerLabel.font = .fontBold18
        headerLabel.textColor = Colors().colorDarkGray

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy - HH:mm"
        formatter.locale = Locale.current
        dateLabel.text = formatter.string(from: viewModel.orderDate)
        dateLabel.font = .fontRegular14
        dateLabel.textColor = .gray

        totalLabel.text = String(format: "order_total_label".localized, String(format: "%.2f", viewModel.totalPrice))
        totalLabel.font = .fontBold24
        totalLabel.textColor = Colors().colorDarkGray
        totalLabel.textAlignment = .center

        [headerLabel, dateLabel, tableView, totalLabel].forEach {
            view.addSubview($0)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.size.equalTo(CGSize(width: 32, height: 32))
        }
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(OrderDetailItemCell.self, forCellReuseIdentifier: OrderDetailItemCell.identifier)
        tableView.backgroundColor = Colors().colorWhite

        headerLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(totalLabel.snp.top).offset(-12)
        }

        totalLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension OrderDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailItemCell.identifier, for: indexPath) as! OrderDetailItemCell
        cell.configure(with: item)
        return cell
    }
}
