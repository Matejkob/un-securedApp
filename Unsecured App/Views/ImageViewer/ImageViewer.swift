//
//  ImageViewer.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 20/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit
import SnapKit

final class ImageViewer: UIViewController {

    private let movieLoading = MovieLoading()
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
    private let imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchImage()
    }
}

private extension ImageViewer {
    func setupView() {
        setupScrollView()
        setupImageView()
        setupTapGestureRecognizer()
    }
    
    func setupScrollView() {
        scrollView.backgroundColor = UIColor.black.withAlphaComponent(0.90)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    func setupTapGestureRecognizer() {
        tapGestureRecognizer.numberOfTapsRequired = 2
        tapGestureRecognizer.addTarget(self, action: #selector(doubleTapImage(_:)))
        
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func doubleTapImage(_ sender: UITapGestureRecognizer) {
        let zoomScale: CGFloat = scrollView.zoomScale == 1 ? 2.5 : 1
        scrollView.setZoomScale(zoomScale, animated: true)
    }
}

private extension ImageViewer {
    func fetchImage() {
        movieLoading.show(in: view)
        imageView.kf.setImage(with: imageURL, completionHandler: { [weak self] _ in
            self?.movieLoading.dissmis()
        })
    }
}

extension ImageViewer: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
