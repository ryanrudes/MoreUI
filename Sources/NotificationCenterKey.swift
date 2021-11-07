//
//  NotificationCenterKey.swift
//  MoreUI
//
//  Created by Ryan Rudes on 11/7/21.
//

import SwiftUI

private struct NotificationCenterKey: EnvironmentKey {
    static let defaultValue = UNUserNotificationCenter.current()
}

extension EnvironmentValues {
    /// Delivers local notifications.
    var notificationCenter: UNUserNotificationCenter {
        get { self[NotificationCenterKey.self] }
        set { self[NotificationCenterKey.self] = newValue }
    }
}

extension UNUserNotificationCenter {
    /// Schedules a local notification for delivery.
    /// - Parameters:
    ///   - title: The localized title, containing the reason for the alert.
    ///   - subtitle: The localized subtitle, containing a secondary description of the reason for the alert.
    ///   - body: The localized message to display in the notification alert.
    ///   - badge: The number to apply to the app’s icon.
    ///   - sound: The sound to play when the system delivers the notification.
    ///   - launchImageName: The name of the custom launch image to display when the system launches your app in response to the notification.
    ///   - userInfo: A dictionary of custom information associated with the notification.
    ///   - attachments: An array of attachments to display in an alert-based notification.
    ///   - categoryIdentifier: The identifier of the category object that represents the notification’s type.
    ///   - threadIdentifier: An identifier that you use to group related notifications together.
    ///   - targetContentIdentifier: A value your app uses to identify the notification content.
    ///   - interruptionLevel: The interruption level determines the degree of interruption associated with the notification.
    ///   - relevanceScore: The value the system uses to sort your app’s notifications.
    ///   - options: The authorization options your app is requesting. You may combine the available constants to request authorization for multiple items. Request only the authorization options that you plan to use. For a list of possible values, see ``UNAuthorizationOptions``.
    ///   - trigger: The condition that causes the system to deliver the notification. Specify `nil` to deliver the notification right away. See ``UNNotificationTrigger`` for documentation on concrete trigger classes.
    @available(iOS 15.0, *)
    func post(title: String,
              subtitle: String,
              body: String,
              badge: NSNumber? = nil,
              sound: UNNotificationSound? = .default,
              launchImageName: String? = nil,
              userInfo: [AnyHashable : Any] = [:],
              attachments: [UNNotificationAttachment] = [],
              categoryIdentifier: String? = nil,
              threadIdentifier: String? = nil,
              targetContentIdentifier: String? = nil,
              interruptionLevel: UNNotificationInterruptionLevel? = nil,
              relevanceScore: Double? = nil,
              options: UNAuthorizationOptions = [],
              trigger: UNNotificationTrigger? = nil
    ) {
        _post(title: title, subtitle: subtitle, body: body, badge: badge, sound: sound, launchImageName: launchImageName, userInfo: userInfo, attachments: attachments, summaryArgument: nil, summaryArgumentCount: nil, categoryIdentifier: categoryIdentifier, threadIdentifier: threadIdentifier, targetContentIdentifier: targetContentIdentifier, interruptionLevel: interruptionLevel, relevanceScore: relevanceScore, options: options, trigger: trigger)
    }
        
    /// Schedules a local notification for delivery.
    /// - Parameters:
    ///   - title: The localized title, containing the reason for the alert.
    ///   - subtitle: The localized subtitle, containing a secondary description of the reason for the alert.
    ///   - body: The localized message to display in the notification alert.
    ///   - badge: The number to apply to the app’s icon.
    ///   - sound: The sound to play when the system delivers the notification.
    ///   - launchImageName: The name of the custom launch image to display when the system launches your app in response to the notification.
    ///   - userInfo: A dictionary of custom information associated with the notification.
    ///   - attachments: An array of attachments to display in an alert-based notification.
    ///   - summaryArgument: The string the notification adds to the category’s summary format string.
    ///   - summaryArgumentCount: The number of items the notification adds to the category’s summary format string.
    ///   - categoryIdentifier: The identifier of the category object that represents the notification’s type.
    ///   - threadIdentifier: An identifier that you use to group related notifications together.
    ///   - targetContentIdentifier: A value your app uses to identify the notification content.
    ///   - interruptionLevel: The interruption level determines the degree of interruption associated with the notification.
    ///   - relevanceScore: The value the system uses to sort your app’s notifications.
    ///   - options: The authorization options your app is requesting. You may combine the available constants to request authorization for multiple items. Request only the authorization options that you plan to use. For a list of possible values, see ``UNAuthorizationOptions``.
    ///   - trigger: The condition that causes the system to deliver the notification. Specify `nil` to deliver the notification right away. See ``UNNotificationTrigger`` for documentation on concrete trigger classes.
    @available(iOS, deprecated: 15.0)
    func post(title: String,
              subtitle: String,
              body: String,
              badge: NSNumber? = nil,
              sound: UNNotificationSound? = .default,
              launchImageName: String? = nil,
              userInfo: [AnyHashable : Any] = [:],
              attachments: [UNNotificationAttachment] = [],
              summaryArgument: String? = nil,
              summaryArgumentCount: Int? = nil,
              categoryIdentifier: String? = nil,
              threadIdentifier: String? = nil,
              targetContentIdentifier: String? = nil,
              interruptionLevel: UNNotificationInterruptionLevel? = nil,
              relevanceScore: Double? = nil,
              options: UNAuthorizationOptions = [],
              trigger: UNNotificationTrigger? = nil
    ) {
        _post(title: title, subtitle: subtitle, body: body, badge: badge, sound: sound, launchImageName: launchImageName, userInfo: userInfo, attachments: attachments, summaryArgument: summaryArgument, summaryArgumentCount: summaryArgumentCount, categoryIdentifier: categoryIdentifier, threadIdentifier: threadIdentifier, targetContentIdentifier: targetContentIdentifier, interruptionLevel: interruptionLevel, relevanceScore: relevanceScore, options: options, trigger: trigger)
    }
    
    private func _post(title: String,
                        subtitle: String,
                        body: String,
                        badge: NSNumber? = nil,
                        sound: UNNotificationSound? = .default,
                        launchImageName: String? = nil,
                        userInfo: [AnyHashable : Any] = [:],
                        attachments: [UNNotificationAttachment] = [],
                        summaryArgument: String? = nil,
                        summaryArgumentCount: Int? = nil,
                        categoryIdentifier: String? = nil,
                        threadIdentifier: String? = nil,
                        targetContentIdentifier: String? = nil,
                        interruptionLevel: UNNotificationInterruptionLevel? = nil,
                        relevanceScore: Double? = nil,
                        options: UNAuthorizationOptions = [],
                        trigger: UNNotificationTrigger? = nil) {
        var options = options
        
        if badge != nil { options.insert(.badge) }
        if sound != nil { options.insert(.sound) }
        if sound == .defaultCritical { options.insert(.criticalAlert) }
        options.insert(.alert)
        
        requestAuthorization(options: options) { success, error in
            if success {
                print ("Authorization Granted")
            } else if let error = error {
                print (error.localizedDescription)
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = badge
        content.sound = sound
        
        if let launchImageName = launchImageName {
            content.launchImageName = launchImageName
        }
        
        content.userInfo = userInfo
        content.attachments = attachments
        
        if let summaryArgument = summaryArgument {
            content.summaryArgument = summaryArgument
        }
        
        if let summaryArgumentCount = summaryArgumentCount {
            content.summaryArgumentCount = summaryArgumentCount
        }
        
        if let categoryIdentifier = categoryIdentifier {
            content.categoryIdentifier = categoryIdentifier
        }
        
        if let threadIdentifier = threadIdentifier {
            content.threadIdentifier = threadIdentifier
        }
        
        content.targetContentIdentifier = targetContentIdentifier
        
        if let interruptionLevel = interruptionLevel {
            content.interruptionLevel = interruptionLevel
        }
        
        if let relevanceScore = relevanceScore {
            content.relevanceScore = relevanceScore
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
