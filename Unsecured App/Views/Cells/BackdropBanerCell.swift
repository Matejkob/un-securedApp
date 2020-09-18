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
        guard let url = URL(string: "https://image.tmdb.org/t/p/original" + backdrop.filePath) else { return }
        backdropImageView.kf.setImage(with: url)
    }
}

private extension BackdropBanerCell {
    func setupView() {
        setupContentStackView()
        setupBackdropImageView()
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
        
        contentStackView.addArrangedSubview(backdropImageView)
    }
}
