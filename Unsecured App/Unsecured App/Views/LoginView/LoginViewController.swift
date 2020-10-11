//
//  LoginViewController.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 22/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private let movieLoading = MovieLoading()
    
    private let backgroundImageView = UIImageView()
    private let exitButton = UIButton(type: .infoLight)
    private let contentStackView = UIStackView()
    private let userNameInput = UITextFieldPadding()
    private let passwordInput = UITextFieldPadding()
    private let loginButton = UIButton(type: .roundedRect)
    
    private let authenticationManager: AuthenticationManagerProtocol = AuthenticationManager()
    private var successLoginVoidClosure: (() -> Void)?
    
    init(successLoginVoidClosure: (() -> Void)?) {
        self.successLoginVoidClosure = successLoginVoidClosure
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackgroundImage()
    }
}

private extension LoginViewController {
    func setupView() {
        setupBackgroundImageView()
        setupExitButton()
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
    
    func setupExitButton() {
        let xmarkConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .medium)
        exitButton.setImage(UIImage(systemName: "xmark.circle", withConfiguration: xmarkConfiguration), for: .normal)
        exitButton.tintColor = .systemBackground
        
        exitButton.contentEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        exitButton.addTarget(exitButton, action: #selector(dismissAction), for: .touchUpInside)
        
        backgroundImageView.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(8)
        }
    }
    
    @objc func dismissAction() {
        dismiss(animated: true)
    }
    
    func setupContentStackView() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        
        view.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
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
        passwordInput.isSecureTextEntry = true
        passwordInput.clearsOnBeginEditing = true
        passwordInput.placeholder = "Hasło"
        
        contentStackView.addArrangedSubview(passwordInput)
        passwordInput.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    func setupLoginButton() {
        let height: CGFloat = 50
        
        loginButton.titleLabel?.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 20))
        loginButton.titleLabel?.textColor = .systemIndigo
        loginButton.layer.cornerRadius = height / 2
        loginButton.backgroundColor = .systemBackground
        loginButton.setTitle("Zaloguj", for: .normal)
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        
        contentStackView.addArrangedSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    @objc func loginAction() {
        view.endEditing(true)
        
        guard let username = userNameInput.text, let password = passwordInput.text else { return }
        movieLoading.show(in: view)
        authenticationManager.createSessionWith(username: username, password: password) { [weak self] error in
            DispatchQueue.main.async {
                self?.movieLoading.dissmis()
                
                if let error = error {
                    self?.showAlert(with: error.localizedDescription)
                    return
                }
                
                self?.dismiss(animated: true, completion: {
                    self?.successLoginVoidClosure?()
                })
            }
        }
    }
    
    func showAlert(with message: String) {
        let alertController = UIAlertController(title: "Wystąpił błąd", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Anuluj", style: .cancel)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
    func setupBackgroundImage() {
        let backgroundImages = ["1", "2", "3", "4", "6"].shuffled()
        backgroundImageView.image = UIImage(named: backgroundImages.first ?? "1")
    }
}
