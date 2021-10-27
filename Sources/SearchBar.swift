//
//  SearchBar.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/18/21.
//

import SwiftUI
import UIKit

struct SearchBar: UIViewRepresentable {
    let searchBar: UISearchBar = UISearchBar(frame: .zero)
    
    @Binding var text: String
    
    let placeholder: String
    let prompt: String
    let autocapitalizationType: UITextAutocapitalizationType
    let autocorrectionType: UITextAutocorrectionType
    let barPosition: UIBarPosition
    
    // let scopeButtonTitles: [String]?
    
    init(text: Binding<String>,
         placeholder: String = "Search",
         prompt: String = "Search",
         autocapitalizationType: UITextAutocapitalizationType = .none,
         autocorrectionType: UITextAutocorrectionType = .default,
         barPosition: UIBarPosition = .top) {
        self._text = text
        self.placeholder = placeholder
        self.prompt = prompt
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.barPosition = barPosition
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            UIApplication.shared.endEditing()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        searchBar.delegate = context.coordinator
        searchBar.autocapitalizationType = autocapitalizationType
        searchBar.autocorrectionType = autocorrectionType
        searchBar.placeholder = placeholder
        
        // Delegate attributes
        // searchBar.barPosition = barPosition
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

extension SearchBar {
    func showsBookmarkButton(_ condition: Bool) -> SearchBar {
        searchBar.showsBookmarkButton = condition
        return self
    }
    
    func showsCancelButton(_ condition: Bool) -> SearchBar {
        searchBar.showsCancelButton = condition
        return self
    }
    
    func showsSearchResultsButton(_ condition: Bool) -> SearchBar {
        searchBar.showsSearchResultsButton = condition
        return self
    }
    
    func showsScopeBar(_ condition: Bool) -> SearchBar {
        searchBar.showsScopeBar = condition
        return self
    }
    
    func tint(_ tint: Color) -> SearchBar {
        searchBar.tintColor = UIColor(tint)
        return self
    }
    
    func barTint(_ tint: Color) -> SearchBar {
        searchBar.barTintColor = UIColor(tint)
        return self
    }
    
    func barStyle(_ style: UIBarStyle) -> SearchBar {
        searchBar.barStyle = style
        return self
    }
    
    func searchBarStyle(_ style: UISearchBar.Style) -> SearchBar {
        searchBar.searchBarStyle = style
        return self
    }
    
    func translucent() -> SearchBar {
        searchBar.isTranslucent = true // this is already true by default
        return self
    }
    
    func opaque() -> SearchBar {
        searchBar.isTranslucent = false
        return self
    }
    
    func backgroundImage(_ image: UIImage?) -> SearchBar {
        searchBar.backgroundImage = image
        return self
    }
    
    func scopeBarBackgroundImage(_ image: UIImage?) -> SearchBar {
        searchBar.scopeBarBackgroundImage = image
        return self
    }
}
    
extension String {
    func containsCaseInsensitive(_ string: String) -> Bool {
        return self.localizedCaseInsensitiveContains(string)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
