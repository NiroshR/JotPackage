//
//  SceneDelegate.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-23.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import os
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let app = OSLog(subsystem: "dev.ratnarajah.jot", category: "App Launch")
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            window.rootViewController = UINavigationController(rootViewController: TabBarVC())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        // Clear badges for user when the app loads.
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            os_log(.info, log: self.app, "Login code recieved: %@", url.absoluteString)
            
            if url.absoluteString.contains("reminderWidget-") {
                let parsed = url.absoluteString.replacingOccurrences(of: "myapp://reminderWidget-", with: "")
                os_log(.info, log: self.app, "Login code recieved: %@", parsed)
                
                Reminder.markCompleted(reminderID: parsed) { (status, error) in
                    if let error = error {
                        os_log(.info, log: self.app, "%@", error.localizedDescription)
                        return
                    }
                    
                    if !status {
                        os_log(.info, log: self.app, "Error while saving data")
                        return
                    }
                }
            } // End of Reminder Widget
            
        }
    }
    
}
