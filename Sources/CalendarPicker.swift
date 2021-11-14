//
//  CalendarPicker.swift
//  MoreUI
//
//  Created by Ryan Rudes on 11/14/21.
//

import SwiftUI
import EventKitUI

public struct CalendarPicker: UIViewControllerRepresentable {
    public typealias UIViewControllerType = UINavigationController
    
    private var entityType: EKEntityType
    
    @Binding private var selectedCalendars: [EKCalendar]
    
    private var showsCancelButton: Bool = true
    private var showsDoneButton: Bool = true
    
    fileprivate var displayStyle: EKCalendarChooserDisplayStyle = .allCalendars
    fileprivate var selectionStyle: EKCalendarChooserSelectionStyle = .single
    
    /**
     Initializes a newly created calendar chooser.
     - Parameter selection: The calendars selected by the user.
     */
    public init(selection: Binding<[EKCalendar]>) {
        self._selectedCalendars = selection
        self.entityType = .event
    }
    
    /**
     Initializes a newly created calendar chooser.
     - Parameter selection: The calendars selected by the user.
     - Parameter entityType: The entity type of the calendar. Possible values are [EKEntityType.event](https://developer.apple.com/documentation/eventkit/ekentitytype/event) and [EKEntityType.reminder](https://developer.apple.com/documentation/eventkit/ekentitytype/reminder).
     */
    public init(selection: Binding<[EKCalendar]>, entityType: EKEntityType) {
        self._selectedCalendars = selection
        self.entityType = entityType
    }
    
    public class Coordinator: NSObject, EKCalendarChooserDelegate {
        var parent: CalendarPicker
        
        init(_ parent: CalendarPicker) {
            self.parent = parent
        }
        
        /**
         Sent when a user selects one or more calendars.
         
         - Parameter calendarChooser: The calendar chooser that sent this message.
         */
        public func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
            parent.selectedCalendars = Array(calendarChooser.selectedCalendars)
            calendarChooser.dismiss(animated: true)
        }
        
        /**
         Sent when a user changes the selection.
         - Parameter calendarChooser: The calendar chooser that sent this message.
         
         Use the [selectedCalendars](https://developer.apple.com/documentation/eventkitui/ekcalendarchooser/1613926-selectedcalendars) property to get the current selection.
         */
        public func calendarChooserSelectionDidChange(_ calendarChooser: EKCalendarChooser) {
            
        }
        
        /**
         Sent when the user cancels a calendar selection.
         
         - Parameter calendarChooser: The calendar chooser that sent this message.
         */
        public func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
            calendarChooser.dismiss(animated: true)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UIViewControllerType {
        let eventStore = EKEventStore()
        
        switch EKEventStore.authorizationStatus(for: entityType) {
            case .authorized:
                print("Authorized")
            case .denied:
                print("Access denied")
            case .notDetermined:
                eventStore.requestAccess(to: entityType, completion:
                    {(granted: Bool, error: Error?) -> Void in
                        if granted {
                            print("Access granted")
                        } else {
                            print("Access denied")
                        }
                })
                print("Not Determined")
            default:
                print("Case Default")
        }

        let picker = EKCalendarChooser(selectionStyle: selectionStyle, displayStyle: displayStyle, entityType: entityType, eventStore: eventStore)
        
        picker.showsDoneButton = showsDoneButton
        picker.showsCancelButton = showsCancelButton
        
        picker.delegate = context.coordinator
        
        let controller = UINavigationController(rootViewController: picker)
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

public extension CalendarPicker {
    func displayStyle(_ style: EKCalendarChooserDisplayStyle) -> Self {
        then({ $0.displayStyle = style })
    }
    
    func selectionStyle(_ style: EKCalendarChooserSelectionStyle) -> Self {
        then({ $0.selectionStyle = style })
    }
    
    func cancelButtonHidden() -> Self {
        then({ $0.showsCancelButton = false })
    }
    
    func doneButtonHidden() -> Self {
        then({ $0.showsDoneButton = false })
    }
}
