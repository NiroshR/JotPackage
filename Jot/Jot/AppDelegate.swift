//
//  AppDelegate.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-23.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit
import JotUIKit
import CoreData
import Firebase
import os

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        guard let googleAppID: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_GOOGLE_APP_ID") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google App ID.")
            return false
        }
        
        guard let gcmSenderID: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_GCM_SENDER_ID") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase GCM Sender ID.")
            return false
        }
        
        guard let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_API_KEY") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google API Key.")
            return false
        }
        
        guard let projectID: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_PROJECT_ID") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google Project ID.")
            return false
        }
        
        guard let bundleID: String = Bundle.main.bundleIdentifier else {
            os_log(.info, log: self.app, "Error getting App Bundle ID for Firebase.")
            return false
        }
        
        guard let clientID: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_CLIENT_ID") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google Client ID.")
            return false
        }
        
        guard let databaseURL: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_DATABASE_URL") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google Database URL.")
            return false
        }
        
        let secondaryOptions = FirebaseOptions(googleAppID: googleAppID,
                                               gcmSenderID: gcmSenderID)
        secondaryOptions.apiKey = apiKey
        secondaryOptions.projectID = projectID
        
        secondaryOptions.bundleID = bundleID
        secondaryOptions.clientID = clientID
        secondaryOptions.databaseURL = databaseURL
        
        FirebaseApp.configure(options: secondaryOptions)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

