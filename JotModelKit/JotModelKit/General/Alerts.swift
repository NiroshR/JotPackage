//
//  Alerts.swift
//  JotModelKit
//
//  Created by Nirosh Ratnarajah on 2020-06-23.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UserNotifications

public class UserAlerts {
    
    /// Add a notification centre alert.
    /// - Parameter title: Title of notification center alert.
    /// - Parameter body: String of the body of the notification alert.
    /// - Parameter date: When to show the alert to the user.
    /// - Parameter id: ID of the alert, so we can delete/modify it later.
    public static func addAlert(title: String, body: String, date: Date, id: String, completionHandler: @escaping (Error?) -> Void) {
        // Show the permissions popup for the Notification Scheduler.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if success {
                // Schedule alert.
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default
                
                var date = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                date.second = 0
                date.nanosecond = 1
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    // If the error is nil its still fine to send the completion handler.
                    completionHandler(error)
                    return
                }
                
            } else if let error = error {
                completionHandler(error)
                return
            }
            
        }
    }
    
    /// Add a badge on the app icon.
    /// - Parameter date: When to show the badge to the user.
    /// - Parameter id: ID of the badge, so we can delete/modify it later.
    public static func addBadge(date: Date, id: String, completionHandler: @escaping (Error?) -> Void) {
        // Show the permissions popup for the Notification Scheduler.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if success {
                // Schedule alert.
                let content = UNMutableNotificationContent()
                content.badge = 1
                
                // If the date is in the past, don't schedule an alert that
                // can only be triggered in the future.
                if date.startOfDay < Date() {
                    completionHandler(nil)
                    return
                }
                
                var date = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date.startOfDay)
                date.second = 59
                date.nanosecond = 1
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    // If the error is nil its still fine to send the completion handler.
                    completionHandler(error)
                    return
                }
                
            } else if let error = error {
                completionHandler(error)
                return
            }
            
        }
    }
    
    /// Delete a notificaiton alert.
    /// - Parameter id: ID of the alert that was created.
    public static func deleteAlert(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }
    
    /// Update an existing notification centre alert.
    /// - Parameter title: Title of notification center alert.
    /// - Parameter body: String of the body of the notification alert.
    /// - Parameter date: When to show the alert to the user
    /// - Parameter id: ID of the alert to modify.
    public static func updateAlert(title: String, body: String, date: Date, id: String, completionHandler: @escaping (Error?) -> Void) {
        UserAlerts.deleteAlert(id: id)
        
        UserAlerts.addAlert(title: title, body: body, date: date, id: id) { (error) in
            completionHandler(error)
            return
        }
    }
    
    /// Update an existing badge notification.
    /// - Parameter date: When to show the badge to the user.
    /// - Parameter id: ID of the badge to modify.
    public static func updateBadge(date: Date, id: String, completionHandler: @escaping (Error?) -> Void) {
        UserAlerts.deleteAlert(id: id)
        
        UserAlerts.addBadge(date: date, id: id) { (error) in
            completionHandler(error)
            return
        }
    }
    
}
