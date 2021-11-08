//
//  ReferenceLibrary.swift
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
public struct ReferenceLibrary: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    public typealias UIViewControllerType = UIReferenceLibraryViewController
    
    /// The term to define.
    private var term: String
    
    /**
     Initializes a newly created reference-library view to display the definition of the given term.
     - Parameter term: The term to define.
     
     If a definition for the term is not available, a localized message is displayed instead. Use the `dictionaryHasDefinition(forTerm:)` class method to determine whether a definition is available before creating instances of this class.
     */
    init(term: String) {
        self.term = term
    }
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        let controller = UIReferenceLibraryViewController(term: term)
        return controller
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

/// Returns whether a definition is available for the given term.
/// - Parameter term: The term to be defined.
/// - Returns: `true` if a definition for `term` is available; otherwise, `false`.
public func dictionaryHasDefinition(forTerm term: String) -> Bool {
    return UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: term)
}

public extension View {
    /**
     Presents a full-screen reference library when binding to a Boolean value you provide is true.
     
     - Parameter term: A binding to a String value that stores the term to define.
     - Parameter isPresented: A binding to a Boolean value that determines whether to present the sheet.
     - Parameter onDismiss: The closure to execute when dismissing the modal view.
     
     Use this method to show a full-screen reference library. The example below displays a reference library when the user toggles the value of the `isPresenting` binding:
     
     ```swift
     struct ReferenceLibraryPresentedOnDismiss: View {
        @State private var isPresenting = false
     
        var body: some View {
            TextField("Term", text: $term)
                .textInputAutocapitalization(.never)
                .onSubmit {
                    if !term.isEmpty && dictionaryHasDefinition(forTerm: term) {
                        isPresented = true
                    }
                }
                .referenceLibrary(term: $term,
                                  isPresented: $isPresented,
                                  onDismiss: didDismiss)
        }
     
        func didDismiss() {
            // Handle the dismissing action.
        }
     }
     ```
     */
    func referenceLibrary(term: Binding<String>, isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil) -> some View {
        self
            .fullScreenCover(isPresented: isPresented, onDismiss: onDismiss) {
                ReferenceLibrary(term: term.wrappedValue)
            }
    }
}
