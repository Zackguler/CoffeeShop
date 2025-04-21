//
//  UIColor + Extensions.swift
//  CoffeeShop
//
//  Created by Semih Güler on 19.04.2025.
//

import UIKit

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(red: Int, green: Int, blue: Int, reqAlpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: reqAlpha)
    }
    static var peaGreen: UIColor { return UIColor(hexFromString: "#7dbf0d")}
    
}

struct Colors {
    
    let colorWhite = UIColor.init(hexFromString: "#FFFFFF")
    
    let colorBackGround = UIColor.init(hexFromString: "#F8F8F8")
    
    let colorRed = UIColor.init(hexFromString: "#CF092C")
    
    let colorDarkGray = UIColor.init(hexFromString: "#505050")
    
    let colorGray = UIColor.init(hexFromString: "#B5B7B8")
    
    let colorFilterBackground = UIColor.init(hexFromString: "#F4F4F4")
    
    let colorBorder = UIColor.init(hexFromString: "#707070")
    
    let colorBorderLight = UIColor.init(hexFromString: "#B5B7B8")
    
    let colorBlue = UIColor.init(hexFromString: "#175ED0")
    
    let colorLightGrayBorder = UIColor.init(hexFromString: "#D0D0D0")
    
    let colorNormalGray = UIColor.init(hexFromString: "#393939")
    
    let colorLightGray = UIColor.init(hexFromString: "#F2F2F2")
    
    let colorMidGray = UIColor.init(hexFromString: "#ECECEC")
    
    let colorMidBlack = UIColor.init(hexFromString: "#505050")
    
    let colorTrafficRed = UIColor.init(hexFromString: "#FC1B1B")
    
    let colorYellow = UIColor.init(hexFromString: "#FCD11B")
    
    let colorGreen = UIColor.init(hexFromString: "#24D031")
}
