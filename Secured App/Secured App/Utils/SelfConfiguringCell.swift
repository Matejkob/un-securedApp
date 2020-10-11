//
//  SelfConfiguringCell.swift
//  Secured App
//
//  Created by Mateusz Bąk on 17/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with movie: Movie)
}
