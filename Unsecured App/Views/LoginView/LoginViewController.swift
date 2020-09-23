//
//  LoginViewController.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 22/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let backgroundImageView = UIImageView()
    private let contentStackView = UIStackView()
    private let userNameInput = UITextFieldPadding()
    private let passwordInput = UITextFieldPadding()
    private let loginButton = UIButton(type: .roundedRect)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackgroundImage()
    }
}

private extension LoginViewController {
    func setupView() {
        setupBackgroundImageView()
        setupContentStackView()
        setupUserNameInput()
        setupPasswordInput()
        setupLoginButton()
    }
    
    func setupBackgroundImageView() {
        backgroundImageView.contentMode = .scaleAspectFill
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupContentStackView() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        
        view.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
    }
    
    func setupUserNameInput() {
        let height: CGFloat = 50
        
        userNameInput.layer.cornerRadius = height / 2
        userNameInput.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 18))
        userNameInput.clearButtonMode = .whileEditing
        userNameInput.backgroundColor = .systemBackground
        userNameInput.placeholder = "Nazwa użytkownika"
        
        contentStackView.addArrangedSubview(userNameInput)
        userNameInput.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    func setupPasswordInput() {
        let height: CGFloat = 50
        
        passwordInput.layer.cornerRadius = height / 2
        passwordInput.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 18))
        passwordInput.clearButtonMode = .whileEditing
        passwordInput.backgroundColor = .systemBackground
        passwordInput.placeholder = "Hasło"
        
        contentStackView.addArrangedSubview(passwordInput)
        passwordInput.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    func setupLoginButton() {
        let height: CGFloat = 50
        
        loginButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 18))
        loginButton.titleLabel?.textColor = .systemIndigo
        loginButton.layer.cornerRadius = height / 2
        loginButton.backgroundColor = .systemBackground
        loginButton.setTitle("Zaloguj", for: .normal)
        
        contentStackView.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    func setupBackgroundImage() {
        let backgroundImages = ["1", "2", "3", "4", "5", "6"].shuffled()
        backgroundImageView.image = UIImage(named: backgroundImages.first ?? "1")
    }
}
