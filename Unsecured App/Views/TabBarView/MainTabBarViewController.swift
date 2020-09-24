//
//  MainTabBarViewController.swift
//  Unsecured App
//
//  Created by Mateusz Bąk on 22/09/2020.
//  Copyright © 2020 Mateusz Bąk. All rights reserved.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension MainTabBarViewController {
    func setupView() {
        setupRootView()
        addTabs()
    }
    
    func setupRootView() {
        delegate = self
    }
    
    func addTabs() {
        var viewControllersArray = [UIViewController]()
        viewControllersArray.append(buildTab(viewController: HomeViewController(), title: "Filmy", image: UIImage(systemName: "film")!, selectedImage: UIImage(systemName: "film")!))
        viewControllersArray.append(buildTab(viewController: SearchViewController(), title: "Wyszukiwarka", image: UIImage(systemName: "magnifyingglass")!, selectedImage: UIImage(systemName: "magnifyingglass")!))
        viewControllersArray.append(buildTab(viewController: ProfileViewController(), title: "Profil", image: UIImage(systemName: "person")!, selectedImage: UIImage(systemName: "person")!))
        viewControllers = viewControllersArray
    }
}

private extension MainTabBarViewController {
    func buildTab(viewController: UIViewController, title: String?, image: UIImage, selectedImage: UIImage) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.title == "Profil" {
            let loginViewController = LoginViewController {
                
            }
            present(loginViewController, animated: true)
            return false
        }
        
        return true
    }
}
