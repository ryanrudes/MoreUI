//
//  PageView.swift
//  MoreUI
//
//  Created by Ryan Rudes on 11/7/21.
//
//  TODO:
//   - Fix Crash when isDoubleSided is true
//   - Try using a Variadic Tuple View instead of multiple initializers for different sized TupleViews
//   - Create PageViewProxy and PageViewReader
//

import SwiftUI

extension TupleView {
    var getViews: [AnyView] {
        makeArray(from: value)
    }
    
    private struct GenericView {
        let body: Any
        
        var anyView: AnyView? {
            AnyView(_fromValue: body)
        }
    }
    
    private func makeArray<Tuple>(from tuple: Tuple) -> [AnyView] {
        func convert(child: Mirror.Child) -> AnyView? {
            withUnsafeBytes(of: child.value) { ptr -> AnyView? in
                let binded = ptr.bindMemory(to: GenericView.self)
                return binded.first?.anyView
            }
        }
        
        let tupleMirror = Mirror(reflecting: tuple)
        return tupleMirror.children.compactMap(convert)
    }
}

/**
 A view that manages navigation between pages of content.
 
 Important:
 In tvOS, the `PageView` struct provides only a way to swipe between full-screen content pages. Unlike in iOS, a user cannot interact with or move focus between items on each page.
 
 Page view navigation can be controlled programmatically by your app or directly by the user using gestures. When navigating from page to page, the page view uses the transition that you specify to animate the change.
 
 When defining a page view interface, you can provide the content views one at a time (or two at a time, depending upon the spine position and double-sided state) or as-needed using a data source. To support gesture-based navigation, you must provide your views using a data source object.
 */
struct PageView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    public typealias UIViewControllerType = UIPageViewController
    
    @State fileprivate var currentPage: Int = 0
    @State private var previousPage: Int = 0
    
    /**
     The style used to transition between view controllers.
     
     The value of this property is set when the page view controller is initialized, and cannot be changed.
     */
    private var transitionStyle: UIPageViewController.TransitionStyle = .pageCurl
    
    // The direction along which navigation occurs.
    private var navigationOrientation: UIPageViewController.NavigationOrientation
    
    /**
     Space between pages, in points.
     
     The value should be a ``CGFloat`` wrapped in an instance of ``NSNumber``. The default value is zero. An inter-page spacing is only valid if the transition style is `UIPageViewController.TransitionStyle.scroll`.
     */
    private var interPageSpacing: CGFloat = 0
    
    /**
     Location of the spine.
     
     For possible values, see ``UIPageViewController.SpineLocation``. A spine location is only valid if the transition style is `UIPageViewController.TransitionStyle.pageCurl`.

     If the transition style is `UIPageViewController.TransitionStyle.pageCurl`, the default value for this property is `UIPageViewController.SpineLocation.min`; otherwise, the default is `UIPageViewController.SpineLocation.none`.
     */
    private var spineLocation: UIPageViewController.SpineLocation
    
    /**
     A Boolean value that indicates whether content appears on the back of pages.
     
     The default value for this property is `false`.

     If the back of pages has no content (the value is `false`), then the content on the front of the page will partially show through to the back when turning pages.

     If the spine is located in the middle, the value must be `true`. Setting it to `false` with the spine located in the middle raises an exception.
     */
    private var isDoubleSided: Bool = false
    
    // The view controllers displayed by the page view controller.
    private(set) var controllers: [UIViewController]
    
    init<Content>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: @escaping () -> TupleView<(Content, Content)>) where Content: View {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        self.controllers = content().getViews.map { UIHostingController(rootView: $0) }
    }
    
    init<Content>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: @escaping () -> TupleView<(Content, Content, Content)>) where Content: View {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        self.controllers = content().getViews.map { UIHostingController(rootView: $0) }
    }
    
    init<Content>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: @escaping () -> TupleView<(Content, Content, Content, Content)>) where Content: View {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        self.controllers = content().getViews.map { UIHostingController(rootView: $0) }
    }
    
    init<Content>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: @escaping () -> TupleView<(Content, Content, Content, Content, Content)>) where Content: View {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        self.controllers = content().getViews.map { UIHostingController(rootView: $0) }
    }
    
    init<Content>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: @escaping () -> TupleView<(Content, Content, Content, Content, Content, Content)>) where Content: View {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        self.controllers = content().getViews.map { UIHostingController(rootView: $0) }
    }
    
    init<Content>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: @escaping () -> TupleView<(Content, Content, Content, Content, Content, Content, Content)>) where Content: View {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        self.controllers = content().getViews.map { UIHostingController(rootView: $0) }
    }
    
    init<Content>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: @escaping () -> TupleView<(Content, Content, Content, Content, Content, Content, Content, Content)>) where Content: View {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        self.controllers = content().getViews.map { UIHostingController(rootView: $0) }
    }
    
    init<Content>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: @escaping () -> TupleView<(Content, Content, Content, Content, Content, Content, Content, Content, Content)>) where Content: View {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        self.controllers = content().getViews.map { UIHostingController(rootView: $0) }
    }
    
    init<Content>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: @escaping () -> TupleView<(Content, Content, Content, Content, Content, Content, Content, Content, Content, Content)>) where Content: View {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        self.controllers = content().getViews.map { UIHostingController(rootView: $0) }
    }
    
    public init<Data, Content: View, ID: Hashable>(orientation: UIPageViewController.NavigationOrientation = .horizontal, @ViewBuilder _ content: () -> ForEach<Data, ID, Content>) {
        self.navigationOrientation = orientation
        self.spineLocation = transitionStyle == .pageCurl ? .min : .none
        let views = content()
        self.controllers = views.data.map({ UIHostingController(rootView: AnyView(views.content($0))) })
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageView
        
        init(_ parent: PageView) {
            self.parent = parent
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index == 0 {
                return parent.controllers.last
            }
            return parent.controllers[index - 1]
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else {
                return nil
            }
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            return parent.controllers[index + 1]
        }

        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = parent.controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController,
                                spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewController.SpineLocation {
            return parent.spineLocation
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let controller = UIPageViewController(transitionStyle: transitionStyle, navigationOrientation: navigationOrientation)
        controller.isDoubleSided = isDoubleSided
        controller.dataSource = context.coordinator
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard !controllers.isEmpty else {
            return
        }
        
        uiViewController.isDoubleSided = isDoubleSided
        
        let direction: UIPageViewController.NavigationDirection = previousPage < currentPage ? .forward : .reverse
        
        context.coordinator.parent = self
        
        uiViewController.setViewControllers(
            [controllers[currentPage]], direction: direction, animated: false) { _ in
            previousPage = currentPage
        }
    }
}

extension PageView {
    /// Updates the style used to transition between view controllers.
    /// - Parameter style: The style used to transition between view controllers.
    func transitionStyle(_ style: UIPageViewController.TransitionStyle) -> Self {
        then({ $0.transitionStyle = style })
    }
    
    /// Updates the spacing between pages.
    /// - Parameter spacing: Space between pages, in points.
    func interPageSpacing(_ spacing: CGFloat) -> Self {
        return then({ $0.interPageSpacing = spacing })
    }
    
    /// Updates the location of the spine.
    /// - Parameter location: The location of the spine.
    func spineLocation(_ location: UIPageViewController.SpineLocation) -> Self {
        then({
            if location == .mid {
                $0.isDoubleSided = true
            }
            
            $0.spineLocation = location
        })
    }
    
    /// Makes content appear on the back of pages.
    func doubleSided() -> Self {
        then({ $0.isDoubleSided = true })
    }
}
