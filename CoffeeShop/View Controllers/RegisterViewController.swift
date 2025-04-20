//
//  RegisterViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import UIKit
import SnapKit

final class RegisterViewController: UIViewController {
    
    private var buttonText: ViewCheckLabel!
    private var registerButton: CustomButton!
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Üye Ol"
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
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var firstNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("Ad")
        textField.textColor = Colors().colorDarkGray
        return textField
    }()
    
    private lazy var lastNameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("Soyad")
        textField.textColor = Colors().colorDarkGray
        return textField
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("E-Posta")
        textField.keyboardType = .emailAddress
        textField.textColor = Colors().colorDarkGray
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.setPlaceholder("Şifre")
        textField.textColor = Colors().colorDarkGray
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let viewModel: RegisterViewModelProtocol = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().colorWhite
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(containerView)
        containerView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(firstNameTextField)
        mainStackView.addArrangedSubview(lastNameTextField)
        mainStackView.addArrangedSubview(emailTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        
        registerButton = CustomButton.init(action: {
            self.registerTapped()
        })
        registerButton.setTitle("ÜYE OL", for: .normal)
        
        setCheckBox()
        mainStackView.addArrangedSubview(buttonText)
        mainStackView.addArrangedSubview(registerButton)
        
        setButtonAction()
        layout()
    }
    
    private func setButtonAction() {
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
    
    private func setCheckBox() {
        buttonText = ViewCheckLabel(text: "Kampanyalardan haberdar olmak için elektronik ileti almak istiyorum.",
                                    range: "",
                                    action: {
            self.buttonText.buttonCheck.checkboxAnimation {
                // checkbox logic
                if self.buttonText.buttonCheck.isSelected {
                    print("checkbox selected")
                } else {
                    print("checkbox unselected")
                }
            }
        })
        buttonText.labelText.textColor = Colors().colorDarkGray
    }
    
    @objc private func registerTapped() {
        guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespaces), !firstName.isEmpty,
              let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespaces), !lastName.isEmpty,
              let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Hata", message: "Lütfen tüm alanları doldurunuz")
            return
        }
        
        viewModel.register(firstName: firstName,
                          lastName: lastName,
                          email: email,
                          password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = MainTabBarController()
                        window.makeKeyAndVisible()
                    }
                case .failure(let error):
                    self?.showAlert(title: "Kayıt Başarısız", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
}

extension RegisterViewController {
    private func layout() {
        backButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(24)
        }
        
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
        
        firstNameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        buttonText.buttonCheck.snp.remakeConstraints { make in
            make.leading.equalTo(0)
            make.height.width.equalTo(25)
            make.top.equalTo(7)
        }
        buttonText.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
}
