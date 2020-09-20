//
//  MovieLoadingView.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 18/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit
import Lottie
import Kingfisher

final class MovieLoading {
        
    private lazy var animationView: AnimationView = {
        let animationView = AnimationView(name: "movieLoading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        return animationView
    }()
    
    func show(in view: UIView) {
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.center.equalToSuperview()
        }
        
        animationView.play()
    }
    
    func dissmis() {
        UIView.animate(
            withDuration: 0.15,
            animations: { self.animationView.alpha = 0.0 },
            completion: { _ in self.animationView.stop(); self.animationView.removeFromSuperview() }
        )
    }
}
