//
//  ProfileViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 20.04.2025.
//

import UIKit
import SnapKit
import FirebaseAuth

final class ProfileViewController: UIViewController {
    
    private let viewModel: ProfileViewModelProtocol
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = Colors().colorDarkGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var orderHistoryButton: CustomButton = {
        let button = CustomButton {
            self.showOrderHistory()
        }
        button.setTitle("order_history".localized, for: .normal)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .fontBold22
        label.textColor = Colors().colorDarkGray
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .fontRegular16
        label.textColor = Colors().colorDarkGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var logoutButton: CustomButton = {
        let button = CustomButton {
            self.logoutTapped()
        }
        button.setTitle("logout".localized, for: .normal)
        return button
    }()
    
    private lazy var deleteAccountButton: CustomButton = {
        let button = CustomButton {
            self.deleteAccountTapped()
        }
        button.setTitle("delete_account".localized, for: .normal)
        button.backgroundColor = Colors().colorRed
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().colorWhite
        title = "profile_title".localized
        setupUI()
        loadUserInfo()
    }
    
    private func setupUI() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(orderHistoryButton)
        stackView.addArrangedSubview(logoutButton)
        stackView.addArrangedSubview(deleteAccountButton)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.right.equalToSuperview().inset(32)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
        
        deleteAccountButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
        }

        orderHistoryButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
    }
    
    private func showOrderHistory() {
        let historyVC = OrderHistoryViewController()
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    private func loadUserInfo() {
        stackView.isHidden = true
        LoadingManager.shared.show(in: view)

        viewModel.fetchUser { [weak self] user in
            DispatchQueue.main.async {
                self?.nameLabel.text = "\(user.firstName) \(user.lastName)"
                self?.emailLabel.text = user.email

                self?.stackView.isHidden = false
                LoadingManager.shared.hide()
            }
        }
    }
    
    private func logoutTapped() {
        LoadingManager.shared.show(in: view)
        viewModel.logout { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showAlert(title: "error".localized, message: error.localizedDescription)
                } else {
                    self?.goToLogin()
                    LoadingManager.shared.hide()
                }
            }
        }
    }

    private func deleteAccountTapped() {
        let alert = UIAlertController(
            title: "delete_account".localized,
            message: "delete_account_confirm".localized,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        alert.addAction(UIAlertAction(title: "confirm".localized, style: .destructive, handler: { _ in
            LoadingManager.shared.show(in: self.view)

            self.viewModel.deleteAccount { [weak self] error in
                DispatchQueue.main.async {
                    LoadingManager.shared.hide()

                    if let error = error {
                        self?.showAlert(title: "error".localized, message: error.localizedDescription)
                    } else {
                        self?.goToLogin()
                    }
                }
            }
        }))

        present(alert, animated: true)
    }

    private func goToLogin() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        let tabBarController = MainTabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
