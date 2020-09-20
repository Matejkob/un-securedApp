//
//  MoviesBanerCell.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit
import Kingfisher

final class MoviesBanerCell: UICollectionViewCell {
    
    static var reuseIdentifier = "MoviesBanerCell"
    
    private let backdropImageView = UIImageView()
    private let labelsStackView = UIStackView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoviesBanerCell: SelfConfiguringCell {
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = "Premiera za: \(movie.releaseDate) dni"
        guard let backdropPath = movie.backdropPath, let url = URL(string: MoviesImages.baseUrl + backdropPath) else {
            backdropImageView.image = nil
            return
        }
        backdropImageView.kf.setImage(with: url, options: [.transition(.fade(0.75))])
    }
}

private extension MoviesBanerCell {
    func setupView() {
        setupContentView()
        setupBackdropImageView()
        setupLabelsStackView()
        setupTitleLabel()
//        setupReleaseDateLabel()
    }
    
    func setupContentView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 12.0
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 2.0
        contentView.layer.shadowOffset = .init(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.24
    }
    
    func setupBackdropImageView() {
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
        backdropImageView.layer.cornerRadius = 12.0
        backdropImageView.kf.indicatorType = .activity

        contentView.addSubview(backdropImageView)
        backdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupLabelsStackView() {
        labelsStackView.axis = .vertical
        
        backdropImageView.addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(4)
        }
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14, weight: .bold))
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        labelsStackView.addArrangedSubview(titleLabel)
    }
    
    func setupReleaseDateLabel() {
        releaseDateLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 13))
        releaseDateLabel.textColor = .white
        releaseDateLabel.textAlignment = .center
        
        labelsStackView.addArrangedSubview(releaseDateLabel)
    }
}
