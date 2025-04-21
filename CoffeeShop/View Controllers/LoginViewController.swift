//
//  LoginViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModelProtocol = LoginViewModel()
    var onLoginSuccess: (() -> Void)?
    
    private let languageButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: "globe", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = Colors().colorDarkGray
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors().colorBorderLight.cgColor
        view.setCornerRound(value: 8)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "login_title".localized
        label.font = .fontBold24
        label.textColor = Colors().colorDarkGray
        label.textAlignment = .center
        return label
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
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textColor = Colors().colorDarkGray
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("password_placeholder".localized)
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textColor = Colors().colorDarkGray
        return textField
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("forgot_password".localized, for: .normal)
        button.setTitleColor(Colors().colorRed, for: .normal)
        button.titleLabel?.font = .fontRegular14
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton {
            self.loginTapped()
        }
        button.setTitle("login_button".localized, for: .normal)
        return button
    }()
    
    private lazy var goToRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("register_prompt".localized, for: .normal)
        button.setTitleColor(Colors().colorRed, for: .normal)
        button.titleLabel?.font = .fontRegular14
        button.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().colorWhite
        setupUI()
        layout()
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(forgotPasswordButton)
        mainStackView.addArrangedSubview(loginButton)
        mainStackView.addArrangedSubview(goToRegisterButton)
        
        view.addSubview(languageButton)
        
        languageButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(30)
        }
        languageButton.addTarget(self, action: #selector(didTapLanguageButton), for: .touchUpInside)
    }
    
    private func setLanguage(_ code: String) {
        LocalizationManager.shared.currentLanguage = code
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        exit(0)
    }
    
    @objc private func loginTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty else {
            showAlert(title: "error_title".localized, message: "error_fill_fields".localized)
            return
        }
        
        LoadingManager.shared.show(in: view)
        
        viewModel.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                LoadingManager.shared.hide()
                
                switch result {
                case .success:
                    self?.onLoginSuccess?()
                    NotificationCenter.default.post(name: .cartUpdated, object: nil)
                case .failure(let error):
                    self?.showAlert(title: "login_failed_title".localized, message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func didTapLanguageButton() {
        let alert = UIAlertController(title: "Dil Seç", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "🇹🇷 Türkçe", style: .default, handler: { _ in
            self.setLanguage("tr")
        }))
        alert.addAction(UIAlertAction(title: "🇺🇸 English", style: .default, handler: { _ in
            self.setLanguage("en")
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    @objc private func goToRegister() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func forgotPasswordTapped() {
        let vc = ForgetPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController {
    private func layout() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.lessThanOrEqualToSuperview().inset(50)
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
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        goToRegisterButton.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
}
