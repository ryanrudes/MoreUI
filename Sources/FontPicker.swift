//
//  FontPicker.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/29/21.
//

import SwiftUI

/**
 A control for selecting a font that the system provides or the user installs.
 
 ## Overview
 
 Use a `FontPicker` when you want to provide a view that allows the user to select a font. The view binds to a `Font` instance.
 
 The following example creates a basic`FontPicker`.
 
 ```
 @State private var font = Font.title
 
 FontPicker(selection: $font)
 ```
 */
struct FontPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    typealias UIViewControllerType = UIFontPickerViewController
    
    @Binding var selection: Font
    
    /**
     A Boolean value that determines whether to use the system font for all font names in the font picker.
     
     By default, the font picker uses each font face to display that font face name in the font picker. Set this property to true if you want the font picker to display all font names in the system font instead.
     */
    private var displayUsingSystemFont: Bool = false
    
    /**
     A Boolean value that determines whether the font picker should allow the user to select from font faces, or just font families.
     
     By default, the font picker only lists font families, like Times New Roman or Helvetica. Set includeFaces to true so the user can select a specific font face, such as Times New Roman Bold or Helvetica Light Oblique.
     */
    private var includeFaces: Bool = false
    
    /// A predicate to filter fonts based on their traits, like bold, italic, or monospace.
    private var filteredTraits: UIFontDescriptor.SymbolicTraits? = nil
    
    /**
     A predicate to filter fonts based on the languages they support.
     
     By default, the font picker shows all available fonts, regardless of the languages they support. You may prefer to offer only fonts that support certain languages. To restrict the list, set this property to an `NSPredicate` defining the logic the font picker should apply to the fonts' supported languages metadata.

     Use language specifiers in the same format `CFLocale` uses to specify languages in a filter predicate. You can use `filterPredicate(forFilteredLanguages:)` to construct a simple predicate that excludes fonts which don’t support any of a collection of languages you specify.
     */
    private var filteredLanguagesPredicate: NSPredicate? = nil
    
    /// Creates a font picker.
    /// - Parameters:
    ///   - selection: A binding to a property that determines the currently selected font.
    ///   - filteredTraits: A predicate to filter fonts based on their traits, like bold, italic, or monospace.
    ///   - filteredLanguagesPredicate: A predicate to filter fonts based on the languages they support.
    init(selection: Binding<Font>, filteredTraits: UIFontDescriptor.SymbolicTraits? = nil, filteredLanguagesPredicate: NSPredicate? = nil) {
        self._selection = selection
        self.filteredTraits = filteredTraits
        self.filteredLanguagesPredicate = filteredLanguagesPredicate
    }
    
    class Coordinator: NSObject, UIFontPickerViewControllerDelegate {
        var parent: FontPicker
        
        init(_ parent: FontPicker) {
            self.parent = parent
        }
        
        func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
            parent.selection = Font(UIFont(descriptor: viewController.selectedFontDescriptor!, size: viewController.selectedFontDescriptor!.pointSize) as CTFont)
            parent.dismiss()
        }
        
        func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
            parent.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let config = UIFontPickerViewController.Configuration()
        config.displayUsingSystemFont = displayUsingSystemFont
        config.includeFaces = includeFaces
        if let filteredTraits = filteredTraits {
            config.filteredTraits = filteredTraits
        }
        config.filteredLanguagesPredicate = filteredLanguagesPredicate
        let picker = UIFontPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension FontPicker {
    /// Allows the user to select from font faces in addition to just font families.
    func includesFaces() -> Self {
        then({ $0.includeFaces = true })
    }
    
    /// Uses the system font for all font names in the font picker.
    func displayInSystemFont() -> Self {
        then({ $0.displayUsingSystemFont = true })
    }
}
