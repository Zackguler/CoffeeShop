//
//  LoginViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

//
//  LoginViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModelProtocol = LoginViewModel()
    var onLoginSuccess: (() -> Void)?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors().colorBorderLight.cgColor
        view.setCornerRound(value: 8)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Giriş Yap"
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
        textField.placeholder = "E-Posta"
        textField.keyboardType = .emailAddress
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textColor = Colors().colorDarkGray
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Şifre"
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textColor = Colors().colorDarkGray
        return textField
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Şifremi Unuttum?", for: .normal)
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
        button.setTitle("GİRİŞ YAP", for: .normal)
        return button
    }()
    
    private lazy var goToRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Hesabın yok mu? Üye Ol", for: .normal)
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
    }
    
    @objc private func loginTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty else {
            showAlert(title: "Hata", message: "Lütfen tüm alanları doldurunuz.")
            return
        }
        
        viewModel.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.onLoginSuccess?()
                case .failure(let error):
                    self?.showAlert(title: "Giriş Başarısız", message: error.localizedDescription)
                }
            }
        }
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
