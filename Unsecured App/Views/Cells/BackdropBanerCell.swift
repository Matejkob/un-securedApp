//
//  BackdropBanerCell.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 18/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class BackdropBanerCell: UICollectionViewCell {
    
    static var reuseIdentifier = "BackdropBanerCell"
    
    private let contentStackView = UIStackView()
    private let backdropImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BackdropBanerCell {
    func configure(with backdrop: Backdrop) {
        guard let url = URL(string: MoviesImages.baseUrl + backdrop.filePath) else {
            backdropImageView.image = nil
            return
        }
        backdropImageView.kf.setImage(with: url, options: [.transition(.fade(0.75))])
    }
}

private extension BackdropBanerCell {
    func setupView() {
        setupContentView()
        setupContentStackView()
        setupBackdropImageView()
    }
    
    func setupContentView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 12.0
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 2.0
        contentView.layer.shadowOffset = .init(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.24
    }
    
    func setupContentStackView() {
        contentStackView.axis = .vertical
        
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupBackdropImageView() {
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        backdropImageView.layer.cornerRadius = 12.0
        backdropImageView.kf.indicatorType = .activity
        
        contentStackView.addArrangedSubview(backdropImageView)
    }
}
