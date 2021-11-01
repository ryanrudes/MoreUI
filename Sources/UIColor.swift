//
//  UIColor.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/27/21.
//
//  Adds:
//   - initializer from hex string
//   - hue property
//   - hex property
//   - rgba property
//   - rgb property
//   - conformation to CaseIterable
//   - conformation to Comparable
//   - other color sets such as .systemColors
//

import SwiftUI

extension UIColor {
    /// Creates a color object from the specified hex string.
    /// - Parameter hex: Hex string representing a color.
    ///
    /// See ["How to convert a hex color to a UIColor"](https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor) from Hacking With Swift.
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        let hex = hex.replacingOccurrences(of: "#", with: "").uppercased()
        let start = hex.index(hex.startIndex, offsetBy: 1)
        let hexColor = String(hex[start...])

        if hexColor.count == 8 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >>  8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255

                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        } else if hexColor.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff) >> 8) / 255
                
                self.init(red: r, green: g, blue: b, alpha: 1)
                return
            }
        }
        
        return nil
    }
    
    /// The hue of the color object.
    var hue: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)

        return hue
    }
    
    /// The hex string representation of the color object.
    ///
    /// See ["How to convert UIColor to HEX and display in NSLog"](https://stackoverflow.com/a/39358741/13645887) from Stack Overflow.
    var hex: String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }

        let multiplier = CGFloat(255.999999)
        
        if a == 1 {
            return String(format: "#%02lX%02lX%02lX",
                          Int(r * multiplier),
                          Int(g * multiplier),
                          Int(b * multiplier))
        } else {
            return String(format: "#%02lX%02lX%02lX%02lX",
                          Int(r * multiplier),
                          Int(g * multiplier),
                          Int(b * multiplier),
                          Int(a * multiplier))
        }
    }
    
    /// The rgba tuple representation of the color object.
    var rgba: (Int, Int, Int, Int)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        return (
            Int(r * multiplier),
            Int(g * multiplier),
            Int(b * multiplier),
            Int(a * multiplier)
        )
    }
    
    /// The rgb tuple representation of the color object.
    var rgb: (Int, Int, Int)? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else {
            return nil
        }
        
        return (
            Int(r * multiplier),
            Int(g * multiplier),
            Int(b * multiplier)
        )
    }
}

extension UIColor: CaseIterable, Comparable {
    public static func < (lhs: UIColor, rhs: UIColor) -> Bool {
        return lhs.hue < rhs.hue
    }
    
    public static var allCases: [UIColor] {
        return [.systemCyan, systemMint, .tintColor, .label, .secondaryLabel, .tertiaryLabel, .quaternaryLabel, .systemFill, .secondarySystemFill, .tertiarySystemFill, .quaternarySystemFill, .placeholderText, .systemBackground, .secondarySystemBackground, .tertiarySystemBackground, .systemGroupedBackground, .secondarySystemGroupedBackground,. tertiarySystemGroupedBackground, .separator, .opaqueSeparator, .link, .darkText, .lightText, .systemBlue, systemBrown, .systemGreen, .systemIndigo, .systemOrange, .systemPink, .systemPurple, .systemRed, .systemTeal, .systemYellow, .systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6, .clear, .black, .blue, .brown, .cyan, .darkGray, .gray, .green, .lightGray, .magenta, .orange, .purple, .red, .white, .yellow].sorted(by: { $0.hue < $1.hue })
    }
    
    public static var rainbow: [UIColor] {
        return [.red, .orange, .yellow, .green, .blue, .cyan, .systemRed, .systemOrange, .systemYellow, .systemIndigo, .purple, .systemPink, .magenta, .systemGreen, .systemBlue, .systemCyan, .systemMint, .systemPurple, .systemTeal].sorted(by: { $0.hue < $1.hue })
    }
    
    public static var systemColors: [UIColor] {
        return [.systemRed, .systemMint, .systemCyan, .systemBlue, .systemGray, .systemBrown, .systemGreen, .systemPurple, .systemIndigo, .systemYellow, .systemOrange, .systemPink, .systemTeal, .systemBrown, .systemPurple].sorted(by: { $0.hue < $1.hue })
    }
    
    public static var labelColors: [UIColor] {
        return [.label, .secondaryLabel, .tertiaryLabel, .quaternaryLabel]
    }
    
    public static var fillColors: [UIColor] {
        return [.systemFill, .secondarySystemFill, .tertiarySystemFill, .quaternarySystemFill]
    }
    
    public static var standardContentBackgroundColors: [UIColor] {
        return [.systemBackground, .secondarySystemBackground, .tertiarySystemBackground]
    }
    
    public static var groupedContentBackgroundColors: [UIColor] {
        return [.systemGroupedBackground, .secondarySystemGroupedBackground, .tertiarySystemGroupedBackground]
    }
    
    public static var separatorColors: [UIColor] {
        return [.separator, .opaqueSeparator]
    }
    
    public static var nonadaptableColors: [UIColor] {
        return [.darkText, .lightText]
    }
    
    public static var adaptableColors: [UIColor] {
        return [.systemBlue, .systemBrown, .systemGreen, .systemIndigo, .systemOrange, .systemPink, .systemPurple, .systemRed, .systemTeal, .systemYellow]
    }
            
    public static var adaptableGrayColors: [UIColor] {
        return [.systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6]
    }
    
    public static var fixedColors: [UIColor] {
        return [.black, .blue, .brown, .cyan, .darkGray, .gray, .green, .lightGray, .magenta, .orange, .purple, .red, .white, .yellow]
    }
}
