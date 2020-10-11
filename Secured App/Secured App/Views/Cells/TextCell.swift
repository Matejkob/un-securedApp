//
//  TextCell.swift
//  Secured App
//
//  Created by Mateusz Bąk on 18/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class TextCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TextCell"
    
    private let contentStackView = UIStackView()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TextCell {
    func configure(with details: MovieDetails) {
        let attributedString = NSMutableAttributedString(string: details.overview ?? "")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attributedString.length))
        descriptionLabel.attributedText = attributedString
    }
}

private extension TextCell {
    func setupView() {
        setupDescriptionLabel()
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 16))
        descriptionLabel.textColor = .label
        descriptionLabel.textAlignment = .natural
        descriptionLabel.numberOfLines = 0
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

