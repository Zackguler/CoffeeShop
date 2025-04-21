//
//  CartViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit
import SnapKit

final class CartViewController: UIViewController {
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "cart_empty_message".localized
        label.font = UIFont.fontRegular16
        label.textColor = Colors().colorDarkGray
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let tableView = UITableView()
    private let totalLabel = UILabel()
    private let orderButton = CustomButton {}
    private let viewModel: CartViewModelProtocol
    
    init(viewModel: CartViewModelProtocol = CartViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "cart_title".localized
        view.backgroundColor = Colors().colorWhite
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell")
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.backgroundColor = Colors().colorWhite
        tableView.separatorStyle = .none
        
        view.addSubview(totalLabel)
        view.addSubview(orderButton)
        view.addSubview(emptyLabel)
        
        orderButton.setTitle("place_order".localized, for: .normal)
        orderButton.addTarget(self, action: #selector(placeOrderTapped), for: .touchUpInside)
        
        totalLabel.font = UIFont.fontBold16
        totalLabel.textColor = Colors().colorRed
        
        // Layout
        orderButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        totalLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalTo(orderButton.snp.centerY)
        }
        
        tableView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(orderButton.snp.top).offset(-8)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24)
        }
    }
    
    private func loadData() {
        emptyLabel.isHidden = true
        tableView.isHidden = true
        orderButton.isHidden = true
        totalLabel.isHidden = true
        
        LoadingManager.shared.show(in: view)
        
        viewModel.loadCart {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateTotal()
                
                let isEmpty = self.viewModel.cartItems.isEmpty
                self.emptyLabel.isHidden = !isEmpty
                self.tableView.isHidden = isEmpty
                self.orderButton.isHidden = isEmpty
                self.totalLabel.isHidden = isEmpty
                
                LoadingManager.shared.hide()
            }
        }
    }
    
    private func checkIfCartIsEmpty() {
        let isEmpty = viewModel.cartItems.isEmpty
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        orderButton.isHidden = isEmpty
        totalLabel.isHidden = isEmpty
    }
    
    private func updateTotal() {
        totalLabel.text = String(format: "total_label".localized, "\(viewModel.totalPrice)")
    }
    
    @objc private func placeOrderTapped() {
        let orderId = UUID().uuidString.prefix(6).uppercased()
        let orderDate = Date()
        let orderedItems = viewModel.cartItems
        
        viewModel.saveOrderToHistory(orderId: orderId, date: orderDate, items: orderedItems)
        
        viewModel.placeOrder { success in
            DispatchQueue.main.async {
                if success {
                    let summaryVM = OrderSummaryViewModel(
                        orderDate: orderDate,
                        orderId: orderId,
                        items: orderedItems
                    )
                    let vc = OrderSummaryViewController(viewModel: summaryVM)
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.tableView.reloadData()
                    self.updateTotal()
                    NotificationCenter.default.post(name: .cartUpdated, object: nil)
                } else {
                    self.showAlert(title: "order_error_title".localized, message: "order_error_message".localized)
                }
            }
        }
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.cartItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as! CartItemCell
        cell.configure(with: item)
        cell.onIncrease = {
            self.viewModel.increaseQuantity(for: item)
            self.updateTotal()
            self.tableView.reloadData()
            self.checkIfCartIsEmpty()
        }
        cell.onDecrease = {
            self.viewModel.decreaseQuantity(for: item)
            self.updateTotal()
            self.tableView.reloadData()
            self.checkIfCartIsEmpty()
        }
        let isLast = indexPath.row == viewModel.cartItems.count - 1
        cell.setBottomLineVisible(!isLast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
