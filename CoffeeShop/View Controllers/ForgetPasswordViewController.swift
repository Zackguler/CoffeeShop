//
//  ForgetPasswordViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

//
//  ForgetPasswordViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit
import SnapKit

final class ForgetPasswordViewController: UIViewController {
    
    private let viewModel: ForgetPasswordViewModelProtocol = ForgetPasswordViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "forgot_title".localized
        label.font = .fontBold24
        label.textColor = Colors().colorDarkGray
        label.textAlignment = .center
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.tintColor = Colors().colorRed
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors().colorBorderLight.cgColor
        view.setCornerRound(value: 8)
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("email_placeholder".localized)
        textField.keyboardType = .emailAddress
        textField.textColor = Colors().colorDarkGray
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var resetButton: CustomButton = {
        let button = CustomButton {
            self.resetTapped()
        }
        button.setTitle("reset_button_title".localized, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().colorWhite
        setupUI()
        layout()
    }
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(resetButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    private func resetTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            showAlert(title: "error_title".localized, message: "error_empty_email".localized)
            return
        }

        LoadingManager.shared.show(in: view)

        viewModel.sendReset(email: email) { [weak self] result in
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
                switch result {
                case .success:
                    self?.showAlert(title: "success_title".localized, message: "reset_success_message".localized)
                case .failure(let error):
                    self?.showAlert(title: "error_title".localized, message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ForgetPasswordViewController {
    private func layout() {
        backButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(24)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.left.right.equalToSuperview().inset(24)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.bottom.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        resetButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
}
