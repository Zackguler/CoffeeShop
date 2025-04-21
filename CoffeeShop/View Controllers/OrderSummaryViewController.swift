//
//  OrderSummaryViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//


import UIKit
import SnapKit

final class OrderSummaryViewController: UIViewController {
    
    private let viewModel: OrderSummaryViewModelProtocol
    
    private let successImage = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
    private let titleLabel = UILabel()
    private let orderInfoLabel = UILabel()
    private let totalLabel = UILabel()
    private let homeButton = CustomButton {
        print("")
    }
    private let stackView = UIStackView()
    private let tableView = UITableView()
    
    init(viewModel: OrderSummaryViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().colorWhite
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.snp.updateConstraints {
            $0.height.equalTo(tableView.contentSize.height)
        }
    }
    
    private func setupUI() {
        successImage.tintColor = .systemGreen
        successImage.contentMode = .scaleAspectFit
        
        titleLabel.text = "Siparişin Başarıyla Oluşturuldu!"
        titleLabel.font = UIFont.fontRegular16
        titleLabel.textColor = Colors().colorDarkGray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy - HH:mm"
        formatter.locale = Locale(identifier: "tr_TR")
        orderInfoLabel.text = "No: #\(viewModel.orderId)  •  \(formatter.string(from: viewModel.orderDate))"
        orderInfoLabel.textColor = Colors().colorDarkGray
        orderInfoLabel.textAlignment = .center
        orderInfoLabel.font = UIFont.fontRegular16
        
        totalLabel.text = "Toplam: \(String(format: "%.2f", viewModel.totalPrice))₺"
        totalLabel.font = UIFont.fontRegular16
        totalLabel.textColor = Colors().colorDarkGray
        totalLabel.textAlignment = .center
        
        tableView.dataSource = self
        tableView.register(OrderSummaryItemCell.self, forCellReuseIdentifier: OrderSummaryItemCell.identifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 8
        tableView.allowsSelection = false
        tableView.backgroundColor = Colors().colorMidBlack
        
        
        homeButton.setTitle("ANA SAYFAYA DÖN", for: .normal)
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        [successImage, titleLabel, orderInfoLabel, tableView, totalLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(stackView)
        view.addSubview(homeButton)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        homeButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(44)
            $0.top.greaterThanOrEqualTo(stackView.snp.bottom).offset(16)
        }
        successImage.snp.makeConstraints {
            $0.size.equalTo(50)
        }
    }
    
    @objc private func homeTapped() {
        tabBarController?.selectedIndex = 0
        navigationController?.popToRootViewController(animated: true)
    }
}

extension OrderSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderSummaryItemCell.identifier, for: indexPath) as! OrderSummaryItemCell
        cell.configure(with: item)
        return cell
    }
}
