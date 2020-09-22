//
//  MoviesListCell.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 22/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class MoviesListCell: UITableViewCell {
    
    static let reuseIdentifier = "MoviesListCell"
        
    private let posterBackgroundView = UIView()
    private let posterImageView = UIImageView()
    private let descriptionStackView = UIStackView()
    private let titleLabel = UILabel()
    private let ratingStackView = UIStackView()
    private let starImageView = UIImageView()
    private let ratingLabel = UILabel()
    private let overviewLabel = UILabel()
    private let bottomSeparatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoviesListCell {
    func updateView(with movie: Movie) {
        updatePosterImageView(with: movie.posterPath)
        updateTitleLabel(with: movie.title)
        updateRatingLabel(with: movie.voteAverage)
        updateOverviewLabel(with: movie.overview)
    }
}

private extension MoviesListCell {
    func setupView() {
        setupPosterBackgroundView()
        setupPosterImageView()
        setupDescriptionStackView()
        setupTitleLabel()
        setupRatingStackView()
        setupStarImageView()
        setupRatingLabel()
        setupOverviewLabel()
        setupBottomSeparatorView()
    }
    
    func setupPosterBackgroundView() {
        posterBackgroundView.layer.cornerRadius = 8.0
        posterBackgroundView.layer.shadowColor = UIColor.black.cgColor
        posterBackgroundView.layer.shadowRadius = 2.0
        posterBackgroundView.layer.shadowOffset = .init(width: 0, height: 2)
        posterBackgroundView.layer.shadowOpacity = 0.16
        
        contentView.addSubview(posterBackgroundView)
        posterBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20.0)
            make.leading.equalToSuperview().offset(16.0)
            make.width.equalTo(97.5)
            make.height.equalTo(140.5)
            make.bottom.lessThanOrEqualToSuperview().offset(-16.0)
        }
    }
    
    func setupPosterImageView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 8.0
        posterImageView.clipsToBounds = true
        
        posterBackgroundView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupDescriptionStackView() {
        descriptionStackView.axis = .vertical
        descriptionStackView.spacing = 4.0
        
        contentView.addSubview(descriptionStackView)
        descriptionStackView.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(16.0)
            make.top.trailing.equalToSuperview().inset(16.0)
            make.bottom.lessThanOrEqualToSuperview().offset(-16.0)
        }
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 24))
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        descriptionStackView.addArrangedSubview(titleLabel)
    }
    
    func setupRatingStackView() {
        ratingStackView.axis = .horizontal
        ratingStackView.alignment = .center
        ratingStackView.spacing = 4
        
        descriptionStackView.addArrangedSubview(ratingStackView)
    }
    
    func setupStarImageView() {
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .systemYellow
        
        ratingStackView.addArrangedSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
    }
    
    func setupRatingLabel() {
        ratingLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14))
        ratingLabel.textColor = .secondaryLabel
        
        ratingStackView.addArrangedSubview(ratingLabel)
    }
    
    func setupOverviewLabel() {
        overviewLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14))
        overviewLabel.textColor = .secondaryLabel
        overviewLabel.numberOfLines = 4
        
        descriptionStackView.addArrangedSubview(overviewLabel)
        descriptionStackView.setCustomSpacing(16, after: overviewLabel)
    }
    
    func setupBottomSeparatorView() {
        bottomSeparatorView.backgroundColor = .label
        
        contentView.addSubview(bottomSeparatorView)
        bottomSeparatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
            make.height.equalTo(1 / UIScreen.main.scale)
        }
    }
}

private extension MoviesListCell {
    func updatePosterImageView(with posterPath: String?) {
        guard let posterPath = posterPath, let url = URL(string: MoviesImages.baseUrl + posterPath) else {
            posterImageView.image = nil
            return
        }
        posterImageView.kf.setImage(with: url, options: [.transition(.fade(0.75))])
    }
    
    func updateTitleLabel(with title: String) {
        titleLabel.text = title
    }
    
    func updateRatingLabel(with voteAverage: Double) {
        ratingLabel.text = "\(voteAverage)"
    }
    
    func updateOverviewLabel(with overview: String) {
        let attributedString = NSMutableAttributedString(string: overview)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value:paragraphStyle, range :NSMakeRange(0, attributedString.length))
        overviewLabel.attributedText = attributedString
    }
}
