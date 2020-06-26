//
//  TodayViewController.swift
//  JotWidget
//
//  Created by Nirosh Ratnarajah on 2020-06-24.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase
import os
import JotUIKit
import JotModelKit

@objc(TodayViewController)
class TodayViewController: UITableViewController, NCWidgetProviding, RemindersCellDelegate  {
    
    // MARK: -Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    var reminders: Reminders!
    
    // MARK: -Class Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        super.viewDidLoad()
        
        // Show expandable option.
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
        //Registers a class for use in creating new table cells.
        self.tableView.register(RemindersTableCell.self, forCellReuseIdentifier: "checkMarkCellID")
        
        
        // Do any additional setup after loading the view.
        
        if FirebaseApp.app() == nil {
            configureFirebase()
        }
        
        Firestore.firestore().disableNetwork { (error) in
            // Do offline things
            // ...
        }
        
        reminders = Reminders()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Firestore.firestore().enableNetwork { (error) in
            // Do offline things
            // ...
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: -Widget Methods
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        reminders.loadData { (status, error) in
            if let error = error {
                completionHandler(NCUpdateResult.failed)
                print(error.localizedDescription)
                return
            }
            
            if status == false {
                completionHandler(NCUpdateResult.failed)
                print("couldn't load")
                return
            }
            
            self.tableView.reloadData()
        }
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
        self.tableView.reloadData()
    }
    
    // MARK: -Tableview Sections
    
    /// Number of rows per section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reminders.remindersArray.count == 0 {
            self.tableView.setEmptyMessage("No Reminders")
        } else {
            self.tableView.restore()
        }
        
        let activeDisplayMode = self.extensionContext?.widgetActiveDisplayMode
        
        return (activeDisplayMode == .expanded ? min(4, self.reminders.remindersArray.count) : min(2, self.reminders.remindersArray.count))
    }
    
    // MARK: -Tableview Rows
    
    /// Set the text for rows.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkMarkCellID", for: indexPath) as! RemindersTableCell
        
        cell.nameLabel.text = reminders.remindersArray[indexPath.row].title
        cell.checkBox.on = reminders.remindersArray[indexPath.row].isCompleted
        
        // Add delegate to know when the button has been tapped.
        cell.delegate = self
        return cell
    }
    
    /// When you select table cell, takes you to appropriate VC.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: -Helper Functions
    
    /// Change the reminder completion tag.
    func checkBoxTapped(for cell: RemindersTableCell, isOn: Bool) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            os_log(.info, log: self.app, "Unable to get index path of cell pressed")
            return
        }
        
        let id = reminders.remindersArray[indexPath.row].ID
        let url: String = "myapp://reminderWidget-" + id
        
        let myAppUrl = URL(string: url)!
        extensionContext?.open(myAppUrl, completionHandler: { (success) in
            if (!success) {
                // let the user know it failed
            }
        })
        
    }
    
    func configureFirebase() {
        guard let googleAppID: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_WIDGET_GOOGLE_APP_ID") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google App ID.")
            return
        }
        
        guard let gcmSenderID: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_WIDGET_GCM_SENDER_ID") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase GCM Sender ID.")
            return
        }
        
        guard let apiKey: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_WIDGET_API_KEY") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google API Key.")
            return
        }
        
        guard let projectID: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_WIDGET_PROJECT_ID") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google Project ID.")
            return
        }
        
        guard let bundleID: String = Bundle.main.bundleIdentifier else {
            os_log(.info, log: self.app, "Error getting App Bundle ID for Firebase.")
            return
        }
        
        guard let clientID: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_WIDGET_CLIENT_ID") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google Client ID.")
            return
        }
        
        guard let databaseURL: String = Bundle.main.object(forInfoDictionaryKey: "FIREBASE_WIDGET_DATABASE_URL") as? String else {
            os_log(.info, log: self.app, "Error getting Firebase Google Database URL.")
            return
        }
        
        let secondaryOptions = FirebaseOptions(googleAppID: googleAppID,
                                               gcmSenderID: gcmSenderID)
        secondaryOptions.apiKey = apiKey
        secondaryOptions.projectID = projectID
        
        secondaryOptions.bundleID = bundleID
        secondaryOptions.clientID = clientID
        secondaryOptions.databaseURL = databaseURL
        
        FirebaseApp.configure(options: secondaryOptions)
    }
    
}
