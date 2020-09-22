//
//  SearchViewController.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 22/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = NetworkManager<SearchService, Movies>()
        manager.request(from: .movie(query: "ojciec", page: 1)) { result in
            print(result)
        }
    }
}
