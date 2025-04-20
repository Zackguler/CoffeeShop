//
//  SplashViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CoffeeShop"
        label.textColor = Colors().colorRed
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().colorWhite
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return
            }

            let tabBar = MainTabBarController()
            window.rootViewController = tabBar
            window.makeKeyAndVisible()
        }
    }
}
