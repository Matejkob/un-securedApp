//
//  ProfileViewController.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 23/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let movieLoading = MovieLoading()
    
    private let contentStackView = UIStackView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    private let logoutButton = UIButton(type: .roundedRect)
    
    private let authenticationManager: AuthenticationManagerProtocol = AuthenticationManager()
    private let accountNetworkManager = NetworkManager<AccountService, Account>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

private extension ProfileViewController {
    func setupView() {
        setupBackgroundColor()
        setupContentStackView()
        setupAavatarImageView()
        setupNameLabel()
        setupUsernameLabel()
        setupLogoutButton()
    }
    
    func setupBackgroundColor() {
        view.backgroundColor = .systemBackground
    }
    
    func setupContentStackView() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.spacing = 4.0
        
        view.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
    
    func setupAavatarImageView() {
        avatarImageView.layer.cornerRadius = 40.0
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.shadowColor = UIColor.black.cgColor
        avatarImageView.layer.shadowRadius = 2.0
        avatarImageView.layer.shadowOffset = .init(width: 0, height: 2)
        avatarImageView.layer.shadowOpacity = 0.24
        
        contentStackView.addArrangedSubview(avatarImageView)
        contentStackView.setCustomSpacing(20, after: avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(avatarImageView.snp.height)
        }
    }
    
    func setupNameLabel() {
        nameLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 36, weight: .bold))
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        
        contentStackView.addArrangedSubview(nameLabel)
    }
    
    func setupUsernameLabel() {
        usernameLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 30))
        usernameLabel.textColor = .secondaryLabel
        usernameLabel.textAlignment = .center
        
        contentStackView.addArrangedSubview(usernameLabel)
    }
    
    func setupLogoutButton() {
        logoutButton.setTitle("Wyloguj", for: .normal)
        logoutButton.setTitleColor(.systemPink, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func logoutAction() {
        guard let sessionToken = authenticationManager.getSessionToken() else { return }
        movieLoading.show(in: view)
        let deleteSessionNetworkManager = NetworkManager<AuthenticationService, DeleteSession>()
        deleteSessionNetworkManager.request(from: .deleteSession(sessionId: sessionToken)) { [weak self] result in
            DispatchQueue.main.async {
                self?.movieLoading.dissmis()
            }
            switch result {
            case .success(let deleteSession):
                if deleteSession.success {
                    self?.authenticationManager.removeSessionToken()
                    DispatchQueue.main.async {
                        self?.tabBarController?.selectedIndex = 0
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

private extension ProfileViewController {
    func fetchProfile() {
        guard let sessionToken = authenticationManager.getSessionToken() else { return }
        movieLoading.show(in: view)
        accountNetworkManager.request(from: .account(sessionId: sessionToken)) { [weak self] result in
            DispatchQueue.main.async {
                self?.movieLoading.dissmis()
                switch result {
                case .success(let account):
                    self?.updateView(with: account)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func updateView(with account: Account) {
        nameLabel.text = account.name
        usernameLabel.text = account.username
        guard let url = URL(string: "https://www.gravatar.com/avatar/" + account.avatar.gravatar.hash) else { return }
        avatarImageView.kf.setImage(with: url, options: [.transition(.fade(0.75))])
    }
}
