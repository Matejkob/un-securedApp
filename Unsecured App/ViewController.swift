//
//  ViewController.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemPink
        
        let label = UILabel()
        label.text = "Witam"
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }


}

