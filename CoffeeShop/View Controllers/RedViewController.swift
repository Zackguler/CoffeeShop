//
//  RedViewController.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//


import UIKit

class RedViewController: UIViewController {
    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors().colorWhite
    }
}
