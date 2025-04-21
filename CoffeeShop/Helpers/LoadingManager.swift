//
//  LoadingManager.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//


import UIKit

final class LoadingManager {
    static let shared = LoadingManager()

    private var backgroundView: UIView?
    private var activityIndicator: UIActivityIndicatorView?

    private init() {}

    func show(in view: UIView? = nil) {
        guard backgroundView == nil, activityIndicator == nil else { return }

        let targetView = view ?? UIApplication.shared.windows.first { $0.isKeyWindow }

        let bgView = UIView()
        bgView.frame = targetView?.bounds ?? .zero
        bgView.isUserInteractionEnabled = false
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = Colors().colorRed
        spinner.startAnimating()

        bgView.addSubview(spinner)
        spinner.center = bgView.center

        targetView?.addSubview(bgView)

        self.backgroundView = bgView
        self.activityIndicator = spinner
    }

    func hide() {
        activityIndicator?.stopAnimating()
        backgroundView?.removeFromSuperview()

        backgroundView = nil
        activityIndicator = nil
    }
}
