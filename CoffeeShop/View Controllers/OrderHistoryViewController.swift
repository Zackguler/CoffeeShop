//
//  OrderHistoryViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit
import SnapKit

final class OrderHistoryViewController: UIViewController {
    
    private let viewModel: OrderHistoryViewModelProtocol
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let backButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = Colors().colorRed
        return button
    }()
    init(viewModel: OrderHistoryViewModelProtocol = OrderHistoryViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sipariş Geçmişi"
        view.backgroundColor = Colors().colorWhite
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors().colorWhite
        tableView.register(OrderHistoryCell.self, forCellReuseIdentifier: "OrderHistoryCell")
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        tableView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(8)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func fetchData() {
        viewModel.fetchOrders {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension OrderHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groupedOrders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupedOrders[section].orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = viewModel.groupedOrders[indexPath.section].orders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell", for: indexPath) as! OrderHistoryCell
        cell.configure(with: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOrder = viewModel.groupedOrders[indexPath.section].orders[indexPath.row]
        let detailVM = OrderDetailViewModel(order: selectedOrder)
        let detailVC = OrderDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let date = viewModel.groupedOrders[section].date
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        
        let label = UILabel()
        label.text = formatter.string(from: date)
        label.font = .fontBold16
        label.textColor = Colors().colorDarkGray
        label.backgroundColor = Colors().colorWhite
        
        let container = UIView()
        container.addSubview(label)
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().inset(4)
        }
        return container
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
}
