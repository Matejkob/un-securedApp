//
//  MainHeader.swift
//  Secured App
//
//  Created by Mateusz Bąk on 18/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

extension MainHeader {
    struct ViewModel {
        var title = ""
        var subtitle = ""
    }
}

final class MainHeader: UICollectionReusableView {
    
    static let reuseIdentifier = "MainHeader"
    
    private let contentStackView = UIStackView()
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

extension MainHeader {
    func configureView(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}

private extension MainHeader {
    func setupView() {
        setupContentStackView()
//        setupTitleLabel()
        setupSubtitleLabel()
    }
    
    func setupContentStackView() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 4.0
        
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-2)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    func setupTitleLabel() {
        titleLabel.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 36))
        titleLabel.textColor = .label
        
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    func setupSubtitleLabel() {
        subtitleLabel.textColor = .secondaryLabel
        
        contentStackView.addArrangedSubview(subtitleLabel)
    }
}

