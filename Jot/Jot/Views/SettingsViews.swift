//
//  SettingsViews.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-29.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import os
import UIKit
import JotModelKit

extension SettingsVC {
    
    /// Register the default cell for requeue and group the rows to not see extra rows.
    func setupTableView() {
        
        // Group the table view by section. This gets rid of blank horizontal lines where a cell would be.
        self.tableView = UITableView(frame: self.tableView.frame, style: .grouped)
        
        //Registers a class for use in creating new table cells.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCellID")
    }
    
    func signOut() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Delete action will sign out the user.
        let deleteAction = UIAlertAction(title: "Sign Out", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            
            self.hud.textLabel.text = "Signing out..."
            self.hud.show(in: self.view, animated: true)
            
            Authentication.logout { (error) in
                if let error = error {
                    self.hud.dismiss(animated: true)
                    self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                    return
                }
                
                os_log(.info, log: self.app, "User logged out.")
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Don't need to do anything here
        })
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func deleteAccount() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // Show the alert controller with delete account description.
        let alertController = UIAlertController(title: "Delete your Jot account?", message: "This will delete all your profile, settings, reminders, and notes. You cannot revert this action.", preferredStyle: .actionSheet)
        
        // This is the main delete action, if pressed the handler shows the reauthentication alert.
        let deleteAction = UIAlertAction(title: "Permanently Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
            
            // The reauthentication alert controller.
            let ac = UIAlertController(title: "Enter email and password to confirm.", message: nil, preferredStyle: .alert)
            ac.addTextField { (textfield) in
                textfield.tag = 0
                textfield.placeholder = "Your email"
                textfield.autocorrectionType = .no
                textfield.autocapitalizationType = .none
                textfield.spellCheckingType = .no
                textfield.keyboardType = .emailAddress
                textfield.returnKeyType = UIReturnKeyType.next
            }
            
            ac.addTextField { (textfield) in
                textfield.tag = 1
                textfield.placeholder = "Your password"
                textfield.autocorrectionType = .no
                textfield.autocapitalizationType = .none
                textfield.spellCheckingType = .no
                textfield.keyboardType = .asciiCapable
                textfield.isSecureTextEntry = true
                textfield.returnKeyType = UIReturnKeyType.done
            }
            
            // Once the submit button is pressed, the password and email fields are processed.
            let submitAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned ac] _ in
                
                guard let email = ac.textFields?[0].text else {
                    os_log(.info, log: self.app, "No email present.")
                    return
                }
                
                guard let password = ac.textFields?[1].text else {
                    os_log(.info, log: self.app, "No password present.")
                    return
                }
                
                self.hud.textLabel.text = "Deleting your account..."
                self.hud.show(in: self.view, animated: true)
                
                // Reauthenticate user before we can delete the account.
                // TO-DO: Need to delete the reminders and notes of user.
                Authentication.reauthenticate(email: email, password: password) { (error) in
                    if let error = error {
                        self.hud.dismiss(animated: true)
                        self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                        return
                    }
                    
                    // Successfully reauthenticated, we can now delete the account.
                    Authentication.delete { (error) in
                        if let error = error {
                            self.hud.dismiss(animated: true)
                            self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                            return
                        }
                        
                        os_log(.info, log: self.app, "User deleted.")
                    }
                }
                
            }
            
            ac.addAction(submitAction)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in}))
            self.present(ac, animated: true)
        })
        
        // Create cancel button to cancel reauthentication.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in})
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
