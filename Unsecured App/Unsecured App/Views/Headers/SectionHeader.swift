//
//  SectionHeader.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

extension SectionHeader {
    struct ViewModel {
        var title = ""
        var subtitle = ""
    }
}

final class SectionHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "SectionHeader"
    
    private let contentStackView = UIStackView()
    private let topSeparatorView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SectionHeader {
    func configureView(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

private extension SectionHeader {
    func setupView() {
        setupContentStackView()
        setupTopSeparatorView()
        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    func setupContentStackView() {
        contentStackView.axis = .vertical
        
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setupTopSeparatorView() {
        topSeparatorView.backgroundColor = .quaternaryLabel
        
        contentStackView.addArrangedSubview(topSeparatorView)
        contentStackView.setCustomSpacing(10, after: topSeparatorView)
        topSeparatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 22, weight: .bold))
        titleLabel.textColor = .label
        
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    func setupSubtitleLabel() {
        subtitleLabel.textColor = .secondaryLabel
        
        contentStackView.addArrangedSubview(subtitleLabel)
    }
}
