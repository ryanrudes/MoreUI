//
//  DocumentPicker.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/29/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    typealias UIViewControllerType = UIDocumentPickerViewController
    
    @Binding var fileContent: String
    
    private var contentTypes: [UTType]
    private var allowsPickingMultipleItems: Bool = false
    private var directoryURL: URL? = nil
    private var shouldShowFileExtensions: Bool = false
    
    init(fileContent: Binding<String>, forOpeningContentTypes contentTypes: [UTType] = [.data], directoryURL: URL? = nil) {
        self._fileContent = fileContent
        self.contentTypes = contentTypes
        self.directoryURL = directoryURL
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
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
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes)
        picker.allowsMultipleSelection = allowsPickingMultipleItems
        picker.directoryURL = directoryURL
        picker.shouldShowFileExtensions = shouldShowFileExtensions
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension DocumentPicker {
    func allowsMultipleSelection() -> Self {
        then({ $0.allowsPickingMultipleItems = true })
    }
    
    func showsFileExtensions() -> Self {
        then({ $0.shouldShowFileExtensions = true })
    }
}
