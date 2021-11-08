//
//  DocumentPicker.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/29/21.
//

import SwiftUI
import UniformTypeIdentifiers

/// A view that provides access to documents or destinations outside your app’s sandbox.
public struct DocumentPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    public typealias UIViewControllerType = UIDocumentPickerViewController
    
    @Binding private var fileContent: String
    
    private var contentTypes: [UTType]?
    private var urls: [URL]?
    private var asCopy: Bool
    
    /**
     A Boolean value that determines whether the user can select more than one document at a time.
     
     By default, this property is `false`.
     */
    fileprivate var allowsMultipleSelection: Bool = false
    
    /**
     The initial directory that the document picker displays.

     Set this property to specify the starting directory for the document picker. This property defaults to `nil`. If you specify a value, the document picker tries to start at the specified directory. Otherwise, it starts with the last directory chosen by the user.

     The `directoryURL` property only returns a value when you explicitly set it. For example, it doesn’t calculate the default URL presented to the user when the property isn’t set.
     
     - Note: This property has no effect in Mac apps built with Mac Catalyst.
     */
    fileprivate var directoryURL: URL? = nil
    
    /**
     A Boolean value that determines whether the browser always shows file extensions.
     
     The default value is `false`
     
     - Note: This property has no effect in Mac apps built with Mac Catalyst.
     */
    fileprivate var shouldShowFileExtensions: Bool = false
    
    /// Creates and returns a document picker that can export the types of documents you specify.
    /// - Parameter fileContent: A binding to a property that stores the contents of the selected file.
    /// - Parameter urls: An array of documents that the document picker exports.
    public init(fileContent: Binding<String>, forExporting urls: [URL]) {
        self.init(fileContent: fileContent, forExporting: urls, asCopy: false)
    }
    
    /// Creates and returns a document picker that can export or copy the types of documents you specify.
    /// - Parameter fileContent: A binding to a property that stores the contents of the selected file.
    /// - Parameter urls: An array of documents that the document picker exports or copies.
    /// - Parameter asCopy: A Boolean value that indicates whether the document picker copies the selected document.
    public init(fileContent: Binding<String>, forExporting urls: [URL], asCopy: Bool) {
        self._fileContent = fileContent
        self.urls = urls
        self.asCopy = asCopy
    }
    
    /// Creates and returns a document picker that can open the types of documents you specify.
    /// - Parameter fileContent: A binding to a property that stores the contents of the selected file.
    /// - Parameter contentTypes: An array of uniform type identifiers for the document picker to display. For more information, see [Uniform Type Identifiers](https://developer.apple.com/documentation/uniformtypeidentifiers).
    public init(fileContent: Binding<String>, forOpeningContentTypes contentTypes: [UTType] = [.data]) {
        self.init(fileContent: fileContent, forOpeningContentTypes: contentTypes, asCopy: false)
    }
    
    /// Creates and returns a document picker that can open or copy the types of documents you specify.
    /// - Parameter fileContent: A binding to a property that stores the contents of the selected file.
    /// - Parameter contentTypes: An array of uniform type identifiers for the document picker to display. For more information, see [Uniform Type Identifiers](https://developer.apple.com/documentation/uniformtypeidentifiers).
    /// - Parameter asCopy: A Boolean value that indicates whether the document picker copies the selected document.
    public init(fileContent: Binding<String>, forOpeningContentTypes contentTypes: [UTType] = [.data], asCopy: Bool) {
        self._fileContent = fileContent
        self.contentTypes = contentTypes
        self.asCopy = asCopy
    }
    
    public class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            for url in urls {
                guard url.startAccessingSecurityScopedResource() else {
                    // Handle the failure here.
                    continue
                }
                
                defer { url.stopAccessingSecurityScopedResource() }
                
                do {
                    parent.fileContent = try String(contentsOf: url)
                } catch {
                    print (error.localizedDescription)
                }
            }
        }
        
        public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.dismiss()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        var picker: UIDocumentPickerViewController
        
        if let contentTypes = contentTypes {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes, asCopy: asCopy)
        } else {
            picker = UIDocumentPickerViewController(forExporting: urls!, asCopy: asCopy)
        }
        
        picker.allowsMultipleSelection = allowsMultipleSelection
        picker.directoryURL = directoryURL
        picker.shouldShowFileExtensions = shouldShowFileExtensions
        picker.delegate = context.coordinator
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

public extension DocumentPicker {
    func multipleSelectionEnabled() -> Self {
        then({ $0.allowsMultipleSelection = true })
    }
    
    func showsFileExtensions() -> Self {
        then({ $0.shouldShowFileExtensions = true })
    }
    
    func directoryURL(_ url: URL?) -> Self {
        then({ $0.directoryURL = url })
    }
}

public extension View {
    /// Presents a full-screen document picker that can export or copy the types of documents you specify when binding to a Boolean value you provide is true.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the sheet.
    ///   - fileContent: A binding to a property that stores the contents of the selected file.
    ///   - contentTypes: An array of uniform type identifiers for the document picker to display. For more information, see [Uniform Type Identifiers](https://developer.apple.com/documentation/uniformtypeidentifiers).
    ///   - asCopy: A Boolean value that indicates whether the document picker copies the selected document.
    ///   - allowsMultipleSelection: A Boolean value that determines whether the user can select more than one document at a time. By default, this property is `false`.
    ///   - shouldShowFileExtensions: A Boolean value that determines whether the browser always shows file extensions. The default value is `false`. This property has no effect in Mac apps built with Mac Catalyst.
    ///   - directoryURL: The initial directory that the document picker displays. Set this property to specify the starting directory for the document picker. This property defaults to `nil`. If you specify a value, the document picker tries to start at the specified directory. Otherwise, it starts with the last directory chosen by the user. The `directoryURL` property only returns a value when you explicitly set it. For example, it doesn’t calculate the default URL presented to the user when the property isn’t set. This property has no effect in Mac apps built with Mac Catalyst.
    ///   - onDismiss: The closure to execute when dismissing the document picker.
    func documentPicker(isPresented: Binding<Bool>, fileContent: Binding<String>, forOpeningContentTypes contentTypes: [UTType] = [.data], asCopy: Bool = false, allowsMultipleSelection: Bool = false, shouldShowFileExtensions: Bool = false, directoryURL: URL? = nil, onDismiss: (() -> Void)? = nil) -> some View {
        self
            .fullScreenCover(isPresented: isPresented, onDismiss: onDismiss) {
                DocumentPicker(fileContent: fileContent, forOpeningContentTypes: contentTypes, asCopy: asCopy)
                    .then({
                        $0.directoryURL = directoryURL
                        $0.allowsMultipleSelection = allowsMultipleSelection
                        $0.shouldShowFileExtensions = shouldShowFileExtensions
                    })
            }
    }
    
    /// Presents a full-screen document picker that can open the types of documents you specify when binding to a Boolean value you provide is true.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the sheet.
    ///   - fileContent: A binding to a property that stores the contents of the selected file.
    ///   - urls: An array of documents that the document picker exports.
    ///   - asCopy: A Boolean value that indicates whether the document picker copies the selected document.
    ///   - allowsMultipleSelection: A Boolean value that determines whether the user can select more than one document at a time. By default, this property is `false`.
    ///   - shouldShowFileExtensions: A Boolean value that determines whether the browser always shows file extensions. The default value is `false`. This property has no effect in Mac apps built with Mac Catalyst.
    ///   - directoryURL: The initial directory that the document picker displays. Set this property to specify the starting directory for the document picker. This property defaults to `nil`. If you specify a value, the document picker tries to start at the specified directory. Otherwise, it starts with the last directory chosen by the user. The `directoryURL` property only returns a value when you explicitly set it. For example, it doesn’t calculate the default URL presented to the user when the property isn’t set. This property has no effect in Mac apps built with Mac Catalyst.
    ///   - onDismiss: The closure to execute when dismissing the document picker.
    func documentPicker(isPresented: Binding<Bool>, fileContent: Binding<String>, forExporting urls: [URL], asCopy: Bool = false, allowsMultipleSelection: Bool = false, shouldShowFileExtensions: Bool = false, directoryURL: URL? = nil, onDismiss: (() -> Void)? = nil) -> some View {
        self
            .fullScreenCover(isPresented: isPresented, onDismiss: onDismiss) {
                DocumentPicker(fileContent: fileContent, forExporting: urls, asCopy: asCopy)
                    .then({
                        $0.directoryURL = directoryURL
                        $0.allowsMultipleSelection = allowsMultipleSelection
                        $0.shouldShowFileExtensions = shouldShowFileExtensions
                    })
            }
        
    }
}
