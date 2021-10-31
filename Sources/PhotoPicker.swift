//
//  PHPicker.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/31/21.
//
//  TODO: Make view ignore bottom edge safe area
//

import SwiftUI
import PhotosUI

/**
 A view that provides the user interface for choosing assets from the photo library.
 
 ## Overview

 The `PhotoPicker` view is an alternative to ``ImagePicker``. `PhotoPicker` improves stability and reliability, and includes several benefits to developers and users, such as the following:

 - Deferred image loading and recovery UI
 - Reliable handling of large and complex assets, like RAW and panoramic images
 - User-selectable assets that aren’t available for `ImagePicker`
 - Configuration of the picker to display only Live Photos
 - Availability of ``PHLivePhoto`` objects without library access
 - Stricter validations against invalid inputs

 You can present a picker object only once; you can’t reuse it across sessions.
 */
struct PhotoPicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    typealias UIViewControllerType = PHPickerViewController
    
    @Binding var image: Image?
    @Binding var images: [Image]
    
    private var multipleSelection: Bool
    
    private var photoLibrary: PHPhotoLibrary
    
    /**
     The filter you apply to restrict the asset types the picker displays.
     
     By default, displays all asset types: images, Live Photos, and videos.
     */
    private var filter: PHPickerFilter? = .none
    
    /**
     A mode that determines which representation to use if an asset contains more than one.
     
     An asset can contain many representations under the same uniform type identifier, or you can prefer a specific format. This mode determines which representation an ``NSItemProvider`` uses if many exist.

     The system may perform additional transcoding to convert the asset you request to the compatable representation. Use ``PHPickerConfiguration.AssetRepresentationMode.current`` to avoid transcoding, if possible.
     */
    private var preferredAssetRepresentationMode: PHPickerConfiguration.AssetRepresentationMode = .automatic
    
    /**
     An array of asset identifiers to preselect in the picker.

     Preselection works only when initializing a ``PHPickerConfiguration`` object with a photo library. Otherwise, the system returns an error.

     The number of preselected asset identifiers can exceed your selection limit. The system disables the done action until the selection count becomes lower than ``selectionLimit``.

     Additionally, when providing preselected identifiers:

     - Results include all preselected identifiers when canceling the picker.
     - Results don’t include item providers for preselected assets that remain selected.
     - When deselecting all assets, the system keeps the done action enabled.
     */
    private var preselectedAssetIdentifiers: [String] = []
    
    /**
     The maximum number of selections the user can make.
     
     The default value is `1`. Setting the value to `0` sets the selection limit to the maximum that the system supports.
     */
    private var selectionLimit: Int = 1
    
    /// The selection behavior for the picker.
    private var selection: PHPickerConfiguration.Selection = .default
    
    /**
     Creates an instance that selects an image.
     - Parameter image: A ``Binding`` to the variable that represents the selected ``Image``.
     
     This configuration doesn’t return asset identifiers. To create configuration object with the system photo library use ``init(photoLibrary:)``.
     */
    init(image: Binding<Image?>) {
        self._image = image
        self._images = .constant([])
        self.photoLibrary = .shared()
        self.multipleSelection = false
    }

    /**
     Creates an instance that selects multiple images.
     - Parameter images: A ``Binding`` to the variable that represents the selected images.
     
     This configuration doesn’t return asset identifiers. To create configuration object with the system photo library use ``init(photoLibrary:)``.
     */
    init(images: Binding<[Image]>) {
        self._image = .constant(nil)
        self._images = images
        self.photoLibrary = .shared()
        self.multipleSelection = true
    }
    
    /**
     Creates an instance that selects an image from a specified photo library.
     - Parameter image: A ``Binding`` to the variable that represents the selected ``Image``.
     - Parameter photoLibrary: The library from which to pick photos and videos.
     */
    init(image: Binding<Image?>, photoLibrary: PHPhotoLibrary) {
        self._image = image
        self._images = .constant([])
        self.photoLibrary = photoLibrary
        self.multipleSelection = false
    }
    
    /**
     Creates an instance that selects multiple images from a specified photo library.
     - Parameter images: A ``Binding`` to the variable that represents the selected images.
     - Parameter photoLibrary: The library from which to pick photos and videos.
     */
    init(images: Binding<[Image]>, photoLibrary: PHPhotoLibrary) {
        self._image = .constant(nil)
        self._images = images
        self.photoLibrary = photoLibrary
        self.multipleSelection = true
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        /// Notifies the delegate that the user completed a selection or dismissed the picker using the cancel button.
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            // parent.itemProviders = results.map(\.itemProvider)
            
            DispatchQueue.main.async { [self] in
                if parent.multipleSelection {
                    loadImages(results: results)
                } else {
                    guard let result = results.first else { return }
                    
                    let provider = result.itemProvider
                    
                    if provider.canLoadObject(ofClass: UIImage.self) {
                        provider.loadObject(ofClass: UIImage.self) { (image, error) in
                            if let image = image as? UIImage {
                                self.parent.image = Image(uiImage: image)
                            } else {
                                print ("Failed to load image", error?.localizedDescription ?? "")
                            }
                        }
                    }
                }
            }
        }
        
        func loadImages(results: [PHPickerResult]) {
            for result in results {
                let provider = result.itemProvider
                
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            self.parent.images.append(Image(uiImage: image))
                        } else {
                            print ("Failed to load image", error?.localizedDescription ?? "")
                        }
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        if multipleSelection {
            guard selectionLimit != 1 else { fatalError() }
        }
        
        var config = PHPickerConfiguration(photoLibrary: photoLibrary)
        config.filter = filter
        config.preferredAssetRepresentationMode = preferredAssetRepresentationMode
        config.preselectedAssetIdentifiers = preselectedAssetIdentifiers
        config.selectionLimit = selectionLimit
        config.selection = selection
        let picker = PHPickerViewController(configuration: config)
        picker.extendedLayoutIncludesOpaqueBars = true
        picker.edgesForExtendedLayout = .bottom
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

extension PhotoPicker {
    /**
     Applies the specified filter which restricts the asset types the picker displays.
     - Parameter filter: The filter you apply to restrict the asset types the picker displays.
     
     By default, a configuration object displays all asset types: images, Live Photos, and videos.
     */
    func filter(_ filter: PHPickerFilter?) -> Self {
        then({ $0.filter = filter })
    }
    
    /**
     Selects the mode that determined which representation to use if an asset contains more than one.
     - Parameter mode: A mode that determines which representation to use if an asset contains more than one.
     
     An asset can contain many representations under the same uniform type identifier, or you can prefer a specific format. This mode determines which representation an ``NSItemProvider`` uses if many exist.

     The system may perform additional transcoding to convert the asset you request to the compatable representation. Use ``PHPickerConfiguration.AssetRepresentationMode.current`` to avoid transcoding, if possible.
     */
    func preferredAssetRepresentationMode(_ mode: PHPickerConfiguration.AssetRepresentationMode) -> Self {
        then({ $0.preferredAssetRepresentationMode = mode })
    }
    
    /**
     Preselects an array of asset identifiers.
     - Parameter identifier: An array of asset identifiers to preselect in the picker.
     
     Preselection works only when initializing a ``PHPickerConfiguration`` object with a photo library. Otherwise, the system returns an error.

     The number of preselected asset identifiers can exceed your selection limit. The system disables the done action until the selection count becomes lower than ``selectionLimit``.

     Additionally, when providing preselected identifiers:

     - Results include all preselected identifiers when canceling the picker.
     - Results don’t include item providers for preselected assets that remain selected.
     - When deselecting all assets, the system keeps the done action enabled.
     */
    func preselectedAssetIdentifiers(_ identifiers: [String]) -> Self {
        then({ $0.preselectedAssetIdentifiers = identifiers })
    }
    
    /**
     Applies the specified limit to the number of selections a user can make.
     - Parameter limit: The maximum number of selections the user can make.
     
     The default value is `1`. Setting the value to `0` sets the selection limit to the maximum that the system supports.
     */
    func selectionLimit(_ limit: Int) -> Self {
        guard multipleSelection else { return self }
        return then({ $0.selectionLimit = limit })
    }
    
    /// Uses the selection order made by the user, numbering the selected assets, as opposed to the default selection behavior.
    func keepSelectionOrder() -> Self {
        guard multipleSelection else { return self }
        return then({ $0.selection = .ordered })
    }
}
