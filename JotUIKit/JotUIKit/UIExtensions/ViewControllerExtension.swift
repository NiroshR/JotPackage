//
//  ViewControllerExtension.swift
//  JotUIKit
//
//  Created by Nirosh Ratnarajah on 2020-06-23.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import os
import UIKit

extension UIViewController {
    
    /// Displays an error message to user as an UIAlertAction.
    /// - Parameter title: Title string of alert (will be bolded).
    /// - Parameter message: Message string of alert description.
    public func displayAlertForUser(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    /// Displays an an alert to a user and logs an info string.
    /// - Parameter app: View controller's app logger.
    /// - Parameter log: Log string to for debugging.
    /// - Parameter displayAlert: Text body of alert to user.
    /// - Parameter displayAlertTitle: Display alert title to user.
    /// - Note: Default alert title is "*Error*".
    public func logAndDisplayAlert(app: OSLog, log: String, displayAlert: String, displayAlertTitle: String = "Error") {
        os_log(.info, log: app, "%@", log)
        self.displayAlertForUser(title: displayAlertTitle, message: displayAlert)
    }
    
    /// Asks the delegate if the text field should process the pressing of the return button.
    /// Cycles through text fields according to their tag number and makes that text field the main responder.
    /// - Parameter textField: The text field whose return button was pressed.
    /// - Returns: True if the text field should implement its default behavior for the return button; otherwise, false.
    @objc public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
