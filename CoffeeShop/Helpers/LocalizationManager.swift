//
//  LocalizationManager.swift
//  CoffeeShop
//
//  Created by Semih Güler on 21.04.2025.
//

import UIKit

extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(for: self)
    }
}

final class LocalizationManager {
    static let shared = LocalizationManager()
    private init() {}

    var currentLanguage: String {
        get {
            return (UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String) ?? "en"
        }
        set {
            UserDefaults.standard.set([newValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }

    var bundle: Bundle {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return .main
        }
        return bundle
    }

    func localizedString(for key: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
