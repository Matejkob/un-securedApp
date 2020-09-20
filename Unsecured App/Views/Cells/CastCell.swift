//
//  CastCell.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 18/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class CastCell: UICollectionViewCell {
    
    static var reuseIdentifier = "CastCell"
    
    private let contentStackView = UIStackView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let characterLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        profileImageView.contentMode = .scaleAspectFill
    }
}

extension CastCell {
    func configure(with cast: Cast) {
        nameLabel.text = cast.name
        characterLabel.text = cast.character
        guard let profilePath = cast.profilePath, let url = URL(string: MoviesImages.baseUrl + profilePath) else {
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.label)
            profileImageView.tintColor = .label
            profileImageView.contentMode = .scaleAspectFit
            return
        }
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.kf.setImage(with: url, options: [.transition(.fade(0.75))])
    }
}

private extension CastCell {
    func setupView() {
        setupContentStackView()
        setupProfileImageView()
        setupNameLabel()
        setupCharacterLabel()
    }
    
    func setupContentStackView() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupProfileImageView() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 8
        
        contentStackView.addArrangedSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.height.equalTo(profileImageView.snp.width).multipliedBy(1.5)
        }
    }
    
    func setupNameLabel() {
        nameLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14))
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        contentStackView.addArrangedSubview(nameLabel)
    }
    
    func setupCharacterLabel() {
        characterLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 13))
        characterLabel.textColor = .secondaryLabel
        characterLabel.numberOfLines = 0
        characterLabel.textAlignment = .center
        
        contentStackView.addArrangedSubview(characterLabel)
    }
}
