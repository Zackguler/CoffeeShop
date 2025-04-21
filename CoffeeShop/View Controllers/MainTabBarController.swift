//
//  MainTabBarController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewControllers()
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors().colorWhite
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        tabBar.tintColor = Colors().colorRed
        tabBar.unselectedItemTintColor = Colors().colorRed
        self.delegate = self
    }
    
    private func setupViewControllers() {
        let home = createNavController(rootViewController: HomeViewController(), title: "Home", imageName: "house")
        let cart = createNavController(rootViewController: CartViewController(), title: "Sepet", imageName: "cart")
        let products = createNavController(rootViewController: ProductListViewController(), title: "Ürünler", imageName: "list.bullet")
        
        let profileVC = makeProfileOrLoginViewController()
        
        let profileNav: UIViewController
        if profileVC is UINavigationController {
            profileNav = profileVC
        } else {
            profileNav = createNavController(rootViewController: profileVC, title: "Profil", imageName: "person")
        }
        
        viewControllers = [home, cart, products, profileNav]
    }
    
    private func createNavController(rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.isNavigationBarHidden = true
        navController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: viewControllers?.count ?? 0)
        return navController
    }
    
    private func makeProfileOrLoginViewController() -> UIViewController {
        let profileViewModel = ProfileViewModel()
        
        if profileViewModel.isLoggedIn {
            let profileVC = ProfileViewController(viewModel: profileViewModel)
            profileVC.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)
            return profileVC
        } else {
            let loginVC = LoginViewController()
            loginVC.onLoginSuccess = { [weak self] in
                self?.refreshProfileTab()
            }
            
            let loginNav = UINavigationController(rootViewController: loginVC)
            loginNav.isNavigationBarHidden = true
            loginNav.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)
            return loginNav
        }
    }
    
    private func refreshProfileTab() {
        guard let viewControllers = self.viewControllers,
              let navController = viewControllers.last as? UINavigationController else {
            return
        }
        
        let profileViewModel = ProfileViewModel()
        let profileVC = ProfileViewController(viewModel: profileViewModel)
        navController.setViewControllers([profileVC], animated: true)
        self.selectedIndex = 0
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        UIView.setAnimationsEnabled(false)
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        UIView.setAnimationsEnabled(true)
    }
}
