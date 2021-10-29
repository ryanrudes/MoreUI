//
//  ReferenceLibraryView.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/29/21.
//

import SwiftUI

/**
 A view that displays a standard interface for looking up the definition of a word or term.
 
 ## Overview
 
 A `UIReferenceLibraryViewController` object should not be used to display wordlists, create a standalone dictionary app, or republish the content in any form.

 You create and initialize a reference library view using the init(term:) method. You pass the term to define as the parameter to this method and the definition is displayed. You can present this view modally or as part of another interface. Optionally, use the`dictionaryHasDefinition(forTerm:)` class method to check if a definition is available for a given term before creating an instance—for example, use this method if you want to change the user interface depending on whether a definition is available.
 */
struct ReferenceLibraryView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    typealias UIViewControllerType = UIReferenceLibraryViewController
    
    /// The term to define.
    var term: String
    
    /**
     Initializes a newly created reference-library view to display the definition of the given term.
     - Parameter term: The term to define.
     
     If a definition for the term is not available, a localized message is displayed instead. Use the `dictionaryHasDefinition(forTerm:)` class method to determine whether a definition is available before creating instances of this class.
     */
    init(term: String) {
        self.term = term
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let controller = UIReferenceLibraryViewController(term: term)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

/// Returns whether a definition is available for the given term.
/// - Parameter term: The term to be defined.
/// - Returns: `true` if a definition for `term` is available; otherwise, `false`.
func dictionaryHasDefinition(forTerm term: String) -> Bool {
    return UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: term)
}
