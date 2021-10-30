//
//  Feedback.swift
//  MoreUI
//
//  Created by Ryan Rudes on 10/30/21.
//

import SwiftUI

struct HapticGenerator {
    var style: UIImpactFeedbackGenerator.FeedbackStyle
    
    /**
     Triggers impact feedback.
     - Parameter intensity: The strength of the haptic event. For more information, see the ``CHHapticEvent.ParameterID.hapticIntensity`` property.
     
     Use impact feedback to indicate that an impact has occurred. For example, you might trigger impact feedback when a user interface object collides with another object or snaps into place.
     */
    func impact(_ intensity: CGFloat = 1) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred(intensity: intensity)
    }
    
    /**
     Triggers notification feedback.
     - Parameter notificationType: The type of notification feedback. For a list of valid notification types, see the ``UINotificationFeedbackGenerator.FeedbackType`` enumeration.
     
     This method tells the generator that a task or action has succeeded, failed, or produced a warning. In response, the generator may play the appropriate haptics, based on the provided ``UINotificationFeedbackGenerator.FeedbackType`` value.
     */
    func notificationOccurred(_ notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(notificationType)
    }
    
    /**
     Triggers selection feedback.
     
     This method tells the generator that the user has changed a selection. In response, the generator may play the appropriate haptics. Do not use this feedback when the user makes or confirms a selection; use it only when the selection changes.
     */
    func selectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

/**
 A property wrapper type that triggers haptic feedback.
 
 Create a feedback object by simply applying the `@Feedback` attrubute to a property declaration without providing an initial value. Condition the feedback with an optional style value representing the mass of the colliding objects. For a list of valid feedback styles, see the ``UIImpactFeedbackGenerator.FeedbackStyle`` enumeration. By default, the feedback style will be set to `.medium`.
 
 ```
 @Feedback(.light) var lightFeedback
 ```
 
 In a ``View``, for instance, upon the press of a button, you can trigger one of three types of feedback generators: a standard impact feedback generator, a notification feedback generator, or a selection feedback generator.
 
 When triggering standard impact feedback, you may optionally provide an intensity value representing the strength of the haptic event, which automatically defaults to `1`:
 
 ```
 lightFeedback.impact(0.5)
 ```
 
 When triggering notification feedback, you must provide a notification feedback type. For a list of valid notification types, see the ``UINotificationFeedbackGenerator.FeedbackType`` enumeration.
 
 ```
 lightFeedback.notificationOccurred(.success)
 ```
 
 Finally, to trigger selection feedback, simply call `selectionChanged()`, which takes no arguments:
 
 ```
 lightFeedback.selectionChanged()
 ```
 */
@propertyWrapper
struct Feedback {
    @State private var generator: HapticGenerator
    
    /// Creates a new trigger with a specified impact feedback style.
    /// - Parameter style: A value representing the mass of the colliding objects. For a list of valid feedback styles, see the ``UIImpactFeedbackGenerator.FeedbackStyle`` enumeration.
    init(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        generator = HapticGenerator(style: style)
    }
    
    var wrappedValue: HapticGenerator {
        get {
            generator
        }
        nonmutating set {
            generator = newValue
        }
    }
}
