//
//  MoviesCarouselCell.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit
import Kingfisher

final class MoviesCarouselCell: UICollectionViewCell {
    
    static let reuseIdentifier = "MoviesCarouselCell"
    
    private let posterImageView = UIImageView()
    private let descriptionStackView = UIStackView()
    private let ratingStackView = UIStackView()
    private let starImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoviesCarouselCell: SelfConfiguringCell {
    func configure(with movie: Movie) {
        ratingLabel.text = "\(movie.voteAverage)"
        titleLabel.text = movie.title
        guard let posterPath = movie.posterPath, let url = URL(string: Configurator.imageBaseUrl + posterPath) else {
            posterImageView.image = nil
            return
        }
        posterImageView.kf.setImage(with: url, options: [.transition(.fade(0.75))])
    }
}

private extension MoviesCarouselCell {
    func setupView() {
        setupContentView()
        setupPosterImageView()
        setupDescriptionStackView()
        setupRatingStackView()
        setupStarImageView()
        setupRatingLabel()
        setupTitleLabel()
    }
    
    func setupContentView() {
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8.0
        contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 2.0
        contentView.layer.shadowOffset = .init(width: 0, height: 2)
        contentView.layer.shadowOpacity = 0.16
    }
    
    func setupPosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.masksToBounds = true
        
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(posterImageView.snp.width).multipliedBy(1.553)
        }
    }
    
    func setupDescriptionStackView() {
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = 4.0
        
        contentView.addSubview(descriptionStackView)
        descriptionStackView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview().inset(12)
        }
    }
    
    func setupRatingStackView() {
        ratingStackView.axis = .horizontal
        ratingStackView.alignment = .leading
        ratingStackView.spacing = 6.0
        
        descriptionStackView.addArrangedSubview(ratingStackView)
    }
    
    func setupStarImageView() {
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .systemYellow
        
        ratingStackView.addArrangedSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
    }
    
    func setupRatingLabel() {
        ratingLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 13))
        ratingLabel.textColor = .secondaryLabel
        
        ratingStackView.addArrangedSubview(ratingLabel)
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 16))
        titleLabel.textColor = .label
        
        descriptionStackView.addArrangedSubview(titleLabel)
    }
}
