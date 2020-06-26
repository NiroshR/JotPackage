//
//  LocalStorage.swift
//  JotModelKit
//
//  Created by Nirosh Ratnarajah on 2020-06-23.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

// https://stackoverflow.com/questions/24015506/communicating-and-persisting-data-between-apps-with-app-groups

import Foundation
import os

let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")

private let FirstRunKey = "firstKey"
private let HideCompletedRemindersKey = "hideCompletedKey"
private let BackgroundImageKey = "backgroundImageKey"

/// Set if the app has been signed in before.
/// - Note: To be used to decide if splash screen should be shown.
/// - Important:Default value is false if app has never launched before.
/// - Parameter doneFirstRun: True if user has signed in before, false otherwise.
public func firstRunSet(doneFirstRun: Bool) {
    UserDefaults.standard.set(doneFirstRun, forKey: FirstRunKey)
    os_log(.info, log: app, "Setting local firstKey stored: %d", doneFirstRun)
}

/// Gets boolean value to indicate if app has been signed in before.
/// - Note: To be used to decide if splash screen should be shown.
/// - Important:Default value is false if app has never launched before.
/// - Returns: True if user has signed in before, false otherwise.
public func firstRunCheck() -> Bool {
    let isOnboarded = UserDefaults.standard.bool(forKey: FirstRunKey)
    return isOnboarded
}

/// Sets if the user wants to have their completed reminders to show.
/// - Parameter isHidden: True if user wants reminders to be hidden.
public func hideCompletedRemindersSet(isHidden: Bool) {
    UserDefaults.standard.set(isHidden, forKey: HideCompletedRemindersKey)
    os_log(.info, log: app, "Setting local hideCompletedKey stored: %d", isHidden)
}

/// Gets boolean value to indicate if the reminders are to be hidden.
/// - Returns: True if the user wants reminders hidden, false otherwise.
public func hideCompletedRemindersCheck() -> Bool {
    let hidden = UserDefaults.standard.bool(forKey: HideCompletedRemindersKey)
    return hidden
}

/// Sets the user's background image, through a string.
/// - Parameter backgroundImage: String of background image.
public func backgroundImageSet(image: String) {
    UserDefaults.standard.set(image, forKey: BackgroundImageKey)
    os_log(.info, log: app, "Setting local backgroundImageKey stored: %@", image)
}

/// Gets background image set by user, if not set uses default.
/// - Returns: User picked background image or default.
public func backgroundImageGet() -> String {
    let imageString: String = UserDefaults.standard.object(forKey: BackgroundImageKey) as? String ?? "Background1"
    return imageString
}
