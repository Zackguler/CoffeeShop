//
//  MainTabBarController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        setupViewControllers()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge), name: .cartUpdated, object: nil)
        updateCartBadge()
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
        let home = createNavController(rootViewController: HomeViewController(), title: "tab_home".localized, imageName: "house")
        let cart = createNavController(rootViewController: CartViewController(), title: "tab_cart".localized, imageName: "cart")
        let products = createNavController(rootViewController: ProductListViewController(), title: "tab_products".localized, imageName: "list.bullet")
        
        let profileVC = makeProfileOrLoginViewController()
        
        let profileNav: UIViewController
        if profileVC is UINavigationController {
            profileNav = profileVC
        } else {
            profileNav = createNavController(rootViewController: profileVC, title: "tab_profile".localized, imageName: "person")
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
            profileVC.tabBarItem = UITabBarItem(title: "tab_profile".localized, image: UIImage(systemName: "person"), tag: 3)
            return profileVC
        } else {
            let loginVC = LoginViewController()
            loginVC.onLoginSuccess = { [weak self] in
                self?.refreshProfileTab()
            }
            
            let loginNav = UINavigationController(rootViewController: loginVC)
            loginNav.isNavigationBarHidden = true
            loginNav.tabBarItem = UITabBarItem(title: "tab_profile".localized, image: UIImage(systemName: "person"), tag: 3)
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
    
    @objc private func updateCartBadge() {
        guard let userID = Auth.auth().currentUser?.uid else {
            tabBar.items?[1].badgeValue = nil
            return
        }

        let cartRef = Firestore.firestore()
            .collection("users")
            .document(userID)
            .collection("cart")

        cartRef.getDocuments { snapshot, error in
            if let error = error {
                print("Cart verisi alınamadı: \(error)")
                return
            }

            var totalQuantity = 0
            snapshot?.documents.forEach { document in
                let data = document.data()
                let quantity = data["quantity"] as? Int ?? 0
                totalQuantity += quantity
            }

            DispatchQueue.main.async {
                if totalQuantity > 0 {
                    self.tabBar.items?[1].badgeValue = "\(totalQuantity)"
                    self.tabBar.items?[1].badgeColor = .red
                } else {
                    self.tabBar.items?[1].badgeValue = nil
                }
            }
        }
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
