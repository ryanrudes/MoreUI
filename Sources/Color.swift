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
//   - uiColor property
//   - conformation to CaseIterable
//   - conformation to Comparable
//   - built-in UIColors, e.g. .magenta, .systemFill, etc.
//

import SwiftUI

extension Color {
    /// Creates a color object from the specified hex string.
    /// - Parameter hex: Hex string representing a color.
    ///
    /// See ``UIColor.init?(hex: String)``.
    public init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else { return nil }
        self.init(uiColor: uiColor)
        return
    }
    
    /// The hue of the color object.
    var hue: CGFloat {
        return uiColor.hue
    }
    
    /// The hex string representation of the color object.
    ///
    /// See ``UIColor.hex``.
    var hex: String? {
        return uiColor.hex
    }
    
    /// The rgba tuple representation of the color object.
    ///
    /// See ``UIColor.rgba``.
    var rgba: (Int, Int, Int, Int)? {
        return uiColor.rgba
    }
    
    /// The rgb tuple representation of the color object.
    ///
    /// See ``UIColor.rgb``.
    var rgb: (Int, Int, Int)? {
        return uiColor.rgb
    }
    
    /// The UIColor that corresponds to the color object.
    var uiColor: UIColor {
        UIColor(self)
    }
}

// SwiftUI Element Colors
extension Color {
    // MARK: - Label Colors
    
    /// The color for text labels that contain primary content.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var label: Color { return Self(UIColor.label) }
    /// The color for text labels that contain secondary content.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var secondaryLabel: Color { return Self(UIColor.secondaryLabel) }
    /// The color for text labels that contain tertiary content.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var tertiaryLabel: Color { return Self(UIColor.tertiaryLabel) }
    /// The color for text labels that contain quaternary content.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var quaternaryLabel: Color { return Self(UIColor.quaternaryLabel) }
    
    // MARK: - Fill Colors
    
    /// An overlay fill color for thin and small shapes.
    ///
    /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
    ///
    /// Use this color to fill thin or small shapes, such as the track of a slider.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var systemFill: Color { return Self(UIColor.systemFill) }
    /// An overlay fill color for medium-size shapes.
    ///
    /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
    ///
    /// Use this color to fill medium-size shapes, such as the background of a switch.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var secondarySystemFill: Color { return Self(UIColor.secondarySystemFill) }
    /// An overlay fill color for large shapes.
    ///
    /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
    ///
    /// Use this color to fill large shapes, such as input fields, search bars, or buttons.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var tertiarySystemFill: Color { return Self(UIColor.tertiarySystemFill) }
    /// An overlay fill color for large areas that contain complex content.
    ///
    /// Use system fill colors for items situated on top of an existing background color. System fill colors incorporate transparency to allow the background color to show through.
    ///
    /// Use this color to fill large areas that contain complex content, such as an expanded table cell.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var quaternarySystemFill: Color { return Self(UIColor.quaternarySystemFill) }
    
    // MARK: - Text Colors
    
    /// The color for placeholder text in controls or text views.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var placeholderText: Color { return Self(UIColor.placeholderText) }
    
    // MARK: - Standard Content Background Colors
    
    /// The color for the main background of your interface.
    ///
    /// Use this color for standard table views and designs that have a white primary background in a light environment.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var systemBackground: Color { return Self(UIColor.systemBackground) }
    /// The color for content layered on top of the main background.
    ///
    /// Use this color for standard table views and designs that have a white primary background in a light environment.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var secondarySystemBackground: Color { return Self(UIColor.secondarySystemBackground) }
    /// The color for content layered on top of secondary backgrounds.
    ///
    /// Use this color for standard table views and designs that have a white primary background in a light environment.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var tertiarySystemBackground: Color { return Self(UIColor.tertiarySystemBackground) }
    
    // MARK: - Grouped Content Background Colors
    
    /// The color for the main background of your grouped interface.
    ///
    /// Use this color for grouped content, including table views and platter-based designs.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var systemGroupedBackground: Color { return Self(UIColor.systemGroupedBackground) }
    /// The color for content layered on top of the main background of your grouped interface.
    ///
    /// Use this color for grouped content, including table views and platter-based designs.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var secondarySystemGroupedBackground: Color { return Self(UIColor.secondarySystemGroupedBackground) }
    /// The color for content layered on top of secondary backgrounds of your grouped interface.
    ///
    /// Use this color for grouped content, including table views and platter-based designs.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var tertiarySystemGroupedBackground: Color { return Self(UIColor.tertiarySystemGroupedBackground) }
    
    // MARK: - Separator Colors
    
    /// The color for thin borders or divider lines that allows some underlying content to be visible.
    ///
    /// This color may be partially transparent to allow the underlying content to show through. It adapts to the underlying trait environment.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var separator: Color { return Self(UIColor.separator) }
    /// The color for borders or divider lines that hides any underlying content.
    ///
    /// This color is always opaque. It adapts to the underlying trait environment.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var opaqueSeparator: Color { return Self(UIColor.opaqueSeparator) }
    
    // MARK: - Link Color
    
    /// The specified color for links.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var link: Color { return Self(UIColor.link) }
    
    // MARK: - Nonadaptable Colors
    
    /// The nonadaptable system color for text on a light background.
    /// - Returns: The `Color` object.
    ///
    /// This color doesn’t adapt to changes in the underlying trait environment.
    @available(iOS 2.0, macCatalyst 2.0, *)
    static var darkText: Color { return Self(UIColor.darkText) }
    
    /// The nonadaptable system color for text on a dark background.
    /// - Returns: The `Color` object.
    ///
    /// This color doesn’t adapt to changes in the underlying trait environment.
    @available(iOS 2.0, macCatalyst 2.0, *)
    static var lightText: Color { return Self(UIColor.lightText) }
}

// SwiftUI Standard Colors
extension Color {
    // MARK: - Adaptable Colors
    
    /// A blue color that automatically adapts to the current trait environment.
    @available(iOS 7.0, macCatalyst 13.0, tvOS 9.0, *)
    static var systemBlue: Color { return Self(UIColor.systemBlue) }
    /// A brown color that automatically adapts to the current trait environment.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var systemBrown: Color { return Self(UIColor.systemBrown) }
    /// A green color that automatically adapts to the current trait environment.
    @available(iOS 7.0, macCatalyst 13.0, tvOS 9.0, *)
    static var systemGreen: Color { return Self(UIColor.systemGreen) }
    /// An indigo color that automatically adapts to the current trait environment.
    @available(iOS 13.0, macCatalyst 13.0, tvOS 13.0, *)
    static var systemIndigo: Color { return Self(UIColor.systemIndigo) }
    /// An orange color that automatically adapts to the current trait environment.
    @available(iOS 7.0, macCatalyst 13.0, tvOS 9.0, *)
    static var systemOrange: Color { return Self(UIColor.systemOrange) }
    /// A pink color that automatically adapts to the current trait environment.
    @available(iOS 7.0, macCatalyst 7.0, tvOS 9.0, *)
    static var systemPink: Color { return Self(UIColor.systemPink) }
    /// A purple color that automatically adapts to the current trait environment.
    @available(iOS 9.0, macCatalyst 13.0, tvOS 9.0, *)
    static var systemPurple: Color { return Self(UIColor.systemPurple) }
    /// A red color that automatically adapts to the current trait environment.
    @available(iOS 7.0, macCatalyst 13.0, tvOS 9.0, *)
    static var systemRed: Color { return Self(UIColor.systemRed) }
    /// A teal color that automatically adapts to the current trait environment.
    @available(iOS 7.0, macCatalyst 7.0, tvOS 9.0, *)
    static var systemTeal: Color { return Self(UIColor.systemTeal) }
    /// A yellow color that automatically adapts to the current trait environment.
    @available(iOS 7.0, macCatalyst 7.0, tvOS 9.0, *)
    static var systemYellow: Color { return Self(UIColor.systemYellow) }
    /// A cyan color that automatically adapts to the current trait environment.
    @available(iOS 15.0, macCatalyst 15.0, tvOS 15.0, *)
    static var systemCyan: Color { return Self(UIColor.systemCyan) }
    /// A mint color that automatically adapts to the current trait environment.
    @available(iOS 15.0, macCatalyst 15.0, tvOS 15.0, *)
    static var systemMint: Color { return Self(UIColor.systemMint) }
    /// The first nondefault tint color value in the view’s hierarchy, ascending from and starting with the view itself.
    @available(iOS 15.0, macCatalyst 15.0, tvOS 15.0, *)
    static var tintColor: Color { return Self(UIColor.tintColor) }
    
    // MARK: - Adaptable Gray Colors
    
    /// The standard base gray color that adapts to the environment.
    ///
    /// This color represents the standard system grey. It adapts to the current environment.
    @available(iOS 7.0, macCatalyst 7.0, tvOS 9.0, *)
    static var systemGray: Color { return Self(UIColor.systemGray) }
    /// A second-level shade of grey that adapts to the environment.
    ///
    /// This color adapts to the current environment. In light environments, this grey is slightly lighter than `systemGray`. In dark environments, this grey is slightly darker than ``systemGray``.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var systemGray2: Color { return Self(UIColor.systemGray2) }
    /// A third-level shade of grey that adapts to the environment.
    ///
    /// This color adapts to the current environment. In light environments, this grey is slightly lighter than ``systemGray2``. In dark environments, this grey is slightly darker than `systemGray2`.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var systemGray3: Color { return Self(UIColor.systemGray3) }
    /// A fourth-level shade of grey that adapts to the environment.
    ///
    /// This color adapts to the current environment. In light environments, this grey is slightly lighter than ``systemGray3``. In dark environments, this grey is slightly darker than `systemGray3`.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var systemGray4: Color { return Self(UIColor.systemGray4) }
    /// A fifth-level shade of grey that adapts to the environment.
    ///
    /// This color adapts to the current environment. In light environments, this grey is slightly lighter than ``systemGray4``. In dark environments, this grey is slightly darker than `systemGray4`.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var systemGray5: Color { return Self(UIColor.systemGray5) }
    /// A sixth-level shade of grey that adapts to the environment.
    ///
    /// This color adapts to the current environment, and is close in color to ``systemBackground``. In light environments, this grey is slightly lighter than ``systemGray5``. In dark environments, this grey is slightly darker than `systemGray5`.
    @available(iOS 13.0, macCatalyst 13.0, *)
    static var systemGray6: Color { return Self(UIColor.systemGray5) }
    
    // MARK: - Fixed Colors
    
    /// A color object with RGB values of `0.0`, `1.0`, and `1.0`, and an alpha value of `1.0`.
    @available(iOS 2.0, macCatalyst 13.0, tvOS 9.0, watchOS 2.0, *)
    static var cyan: Color { return Self(UIColor.cyan) }
    /// A color object with a grayscale value of 1/3 and an alpha value of `1.0`.
    @available(iOS 2.0, macCatalyst 13.0, tvOS 9.0, watchOS 2.0, *)
    static var darkGray: Color { return Self(UIColor.darkGray) }
    /// A color object with a grayscale value of 2/3 and an alpha value of `1.0`.
    @available(iOS 2.0, macCatalyst 13.0, tvOS 9.0, watchOS 2.0, *)
    static var lightGray: Color { return Self(UIColor.lightGray) }
    /// A color object with RGB values of `1.0`, `0.0`, and `1.0`, and an alpha value of `1.0`.
    @available(iOS 2.0, macCatalyst 13.0, tvOS 9.0, watchOS 2.0, *)
    static var magenta: Color { return Self(UIColor.magenta) }
}

/// Conformation to `CaseIterable` protocol.
extension Color: CaseIterable {
    public static var allCases: [Color] {
        return [.systemCyan, systemMint, .tintColor, .label, .secondaryLabel, .tertiaryLabel, .quaternaryLabel, .systemFill, .secondarySystemFill, .tertiarySystemFill, .quaternarySystemFill, .placeholderText, .systemBackground, .secondarySystemBackground, .tertiarySystemBackground, .systemGroupedBackground, .secondarySystemGroupedBackground,. tertiarySystemGroupedBackground, .separator, .opaqueSeparator, .link, .darkText, .lightText, .systemBlue, systemBrown, .systemGreen, .systemIndigo, .systemOrange, .systemPink, .systemPurple, .systemRed, .systemTeal, .systemYellow, .systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6, .clear, .black, .blue, .brown, .cyan, .darkGray, .gray, .green, .lightGray, .magenta, .orange, .purple, .red, .white, .yellow].sorted(by: { $0.hue < $1.hue })
    }
}

/// Conformation to `Comparable` protocol
extension Color: Comparable {
    public static func < (lhs: Color, rhs: Color) -> Bool {
        return lhs.hue < rhs.hue
    }
}

/// More color sets.
extension Color {
    public static var rainbow: [Color] {
        return [.red, .orange, .yellow, .green, .blue, .cyan, .systemRed, .systemOrange, .systemYellow, .systemIndigo, .purple, .systemPink, .magenta, .systemGreen, .systemBlue, .systemCyan, .systemMint, .systemPurple, .systemTeal].sorted(by: { $0.hue < $1.hue })
    }
    
    public static var systemColors: [Color] {
        return [.systemRed, .systemMint, .systemCyan, .systemBlue, .systemGray, .systemBrown, .systemGreen, .systemPurple, .systemIndigo, .systemYellow, .systemOrange, .systemPink, .systemTeal, .systemBrown, .systemPurple].sorted(by: { $0.hue < $1.hue })
    }
    
    public static var labelColors: [Color] {
        return [.label, .secondaryLabel, .tertiaryLabel, .quaternaryLabel]
    }
    
    public static var fillColors: [Color] {
        return [.systemFill, .secondarySystemFill, .tertiarySystemFill, .quaternarySystemFill]
    }
    
    public static var standardContentBackgroundColors: [Color] {
        return [.systemBackground, .secondarySystemBackground, .tertiarySystemBackground]
    }
    
    public static var groupedContentBackgroundColors: [Color] {
        return [.systemGroupedBackground, .secondarySystemGroupedBackground, .tertiarySystemGroupedBackground]
    }
    
    public static var separatorColors: [Color] {
        return [.separator, .opaqueSeparator]
    }
    
    public static var nonadaptableColors: [Color] {
        return [.darkText, .lightText]
    }
    
    public static var adaptableColors: [Color] {
        return [.systemBlue, .systemBrown, .systemGreen, .systemIndigo, .systemOrange, .systemPink, .systemPurple, .systemRed, .systemTeal, .systemYellow]
    }
            
    public static var adaptableGrayColors: [Color] {
        return [.systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .systemGray6]
    }
    
    public static var fixedColors: [Color] {
        return [.black, .blue, .brown, .cyan, .darkGray, .gray, .green, .lightGray, .magenta, .orange, .purple, .red, .white, .yellow]
    }
}
