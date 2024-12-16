////
////  UIColor+Extensions.swift
////  Todoit
////
////  Created by Mischa on 10.12.24.
////
//
//import Foundation
//import UIKit
//
//extension UIColor {
//    convenience init?(hexString: String) {
//        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
//        if hex.hasPrefix("#") {
//            hex.remove(at: hex.startIndex)
//        }
//        
//        guard hex.count == 6 || hex.count == 8 else {
//            return nil // Invalid hex string
//        }
//
//        var rgbValue: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&rgbValue)
//
//        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
//        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
//        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
//        let alpha = hex.count == 8 ? CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0 : 1.0
//
//        self.init(red: red, green: green, blue: blue, alpha: alpha)
//    }
//}

//import Foundation
//import UIKit
//
//extension UIColor {
//    // Initialize UIColor from hex string
//    convenience init?(hexString: String) {
//        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
//        if hex.hasPrefix("#") {
//            hex.remove(at: hex.startIndex)
//        }
//        
//        guard hex.count == 6 || hex.count == 8 else {
//            return nil // Invalid hex string
//        }
//
//        var rgbValue: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&rgbValue)
//
//        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
//        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
//        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
//        let alpha = hex.count == 8 ? CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0 : 1.0
//
//        self.init(red: red, green: green, blue: blue, alpha: alpha)
//    }
//
//    // Check if the color is light or dark
//    func isLight() -> Bool {
//        guard let components = cgColor.components else { return true }
//        let red = components[0]
//        let green = components.count > 1 ? components[1] : red
//        let blue = components.count > 2 ? components[2] : red
//        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
//        return luminance > 0.5
//    }
//
//    // Get a contrasting color (black or white)
//    func contrastColor() -> UIColor {
//        return isLight() ? .black : .white
//    }
//}
//



import Foundation
import UIKit

extension UIColor {
    // Initialize UIColor from a hex string (e.g., "#RRGGBB" or "#RRGGBBAA")
    convenience init?(hexString: String) {
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }

        guard hex.count == 6 || hex.count == 8 else {
            return nil // Invalid hex string
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        let alpha = hex.count == 8 ? CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0 : 1.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    // Check if the color is light or dark based on luminance
    func isLight() -> Bool {
        guard let components = cgColor.components else { return true }
        let red = components[0]
        let green = components.count > 1 ? components[1] : red
        let blue = components.count > 2 ? components[2] : red
        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
        return luminance > 0.5
    }

    // Get a contrasting color (black or white), considering alpha transparency and a background color
    func contrastColor(background: UIColor = .white) -> UIColor {
        var red1: CGFloat = 0, green1: CGFloat = 0, blue1: CGFloat = 0, alpha1: CGFloat = 0
        var red2: CGFloat = 0, green2: CGFloat = 0, blue2: CGFloat = 0, alpha2: CGFloat = 0

        self.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        background.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)

        // Blend foreground color with background based on alpha
        let red = red1 * alpha1 + red2 * (1 - alpha1)
        let green = green1 * alpha1 + green2 * (1 - alpha1)
        let blue = blue1 * alpha1 + blue2 * (1 - alpha1)

        // Calculate luminance of the blended color
        let luminance = (0.299 * red + 0.587 * green + 0.114 * blue)
        return luminance > 0.5 ? .black : .white
    }

    // Adjust brightness of the color by a given percentage (-1.0 to 1.0)
    func adjusted(by percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0

        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        red = min(max(red + percentage * red, 0), 1)
        green = min(max(green + percentage * green, 0), 1)
        blue = min(max(blue + percentage * blue, 0), 1)

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

