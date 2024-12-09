//
//  UIColor+Extensions.swift
//  Todoit
//
//  Created by Mischa on 10.12.24.
//

import Foundation
import UIKit

extension UIColor {
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
}
