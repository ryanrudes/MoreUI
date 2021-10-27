//
//  UIColor.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/27/21.
//
//  - UIColor.hue property variable
//  - CaseIterable extension for UIColor
//  - Comparable extension for UIColor
//

import SwiftUI

extension UIColor {
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
}

extension UIColor: Comparable {
    public static func < (lhs: UIColor, rhs: UIColor) -> Bool {
        return lhs.hue < rhs.hue
    }
}

extension UIColor: CaseIterable {
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
