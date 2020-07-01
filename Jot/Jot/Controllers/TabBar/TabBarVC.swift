//
//  TabBarVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-20.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import FirebaseAuth
import os
import UIKit
import UserNotifications
import JotModelKit

class TabBarVC: UITabBarController {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    var handle: AuthStateDidChangeListenerHandle!
    
    // MARK: Class Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        if Auth.auth().currentUser == nil || !firstRunCheck() {
            presentLoginController()
        }
        
        // Show the permissions popup for the Notification Scheduler.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                os_log(.info, log: self.app, "User notification authorization successful")
            } else if let error = error {
                os_log(.info, log: self.app, "Error getting user notification authorization: %@", error.localizedDescription)
            }
        }
        
        // Add authentication listener. We only show the main application if
        // there is a valid user signed in.
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.setupViewControllers()
            }
            
            if let userDefaults = UserDefaults(suiteName: "group.dev.ratnarajah.Jot") {
                let uid: String = user?.uid ?? ""
                
                userDefaults.set(uid as AnyObject, forKey: "key1")
                userDefaults.synchronize()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        super.viewWillAppear(animated)
        
        // Hide the tab bar navigation bar so we don't have to do it in every
        // view controller that we show in the tab bar controller.
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Helper Functions
    
    fileprivate func presentLoginController() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        DispatchQueue.main.async {
            let welcomeController = AuthenticationVC()
            let welcomeNavigationController = UINavigationController(rootViewController: welcomeController)
            welcomeNavigationController.modalPresentationStyle = .fullScreen
            self.present(welcomeNavigationController, animated: true, completion: nil)
        }
        
    }
    
    func setupViewControllers() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        
        // Load Reminders view controller.
        let remindersVC = RemindersVC()
        let remindersController = UINavigationController(rootViewController: remindersVC)
        remindersController.tabBarItem.title = "Reminders"
        remindersController.tabBarItem.image = UIImage(systemName: "checkmark.square")
        
        // Load Notes view controller.
        let notesVC = NotesVC()
        let notesController = UINavigationController(rootViewController: notesVC)
        notesController.tabBarItem.title = "Notes"
        notesController.tabBarItem.image = UIImage(systemName: "list.bullet")
        
        // Set the color of the navigation bar to mostly transparent and get
        // rid of border with the shadowImage.
        self.tabBar.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        
        // Set the view controllers of the tab bar.
        viewControllers = [remindersController, notesController]
    }
    
}
