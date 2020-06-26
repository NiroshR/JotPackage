//
//  UpdatePasswordVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-22.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import JGProgressHUD
import os
import UIKit
import JotModelKit
import JotUIKit

class UpdatePasswordVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    var reauthenticateTitleLabel: UILabel = createTitleLabel(text: "Re-authenticate", numberOfLines: 0)
    
    var reauthenticateEmailTextField: UITextField = createTextField(tag: 0, placeholder: "Your existing email", identifier: "Your existing email", rounded: "Top")
    
    var reauthenticatePasswordTextField = createPasswordTextField(tag: 1, placeholder: "Your existing password", identifier: "Your existing password", rounded: "Bottom")
    
    var reauthenticateActionButton = createSolidBlueButton(text: "Authenticate", identifier: "Authenticate")
    
    var updatePasswordTitleLabel: UILabel = createTitleLabel(text: "Update Password", numberOfLines: 0)
    
    var updatePasswordTextField = createPasswordTextField(tag: 0, placeholder: "Your new password", identifier: "Your new password", rounded: "Top")
    
    var updateConfirmPasswordTextField = createPasswordTextField(tag: 1, placeholder: "Confirm new password", identifier: "Confirm new password", rounded: "Bottom")
    
    var updatePasswordActionButton = createSolidBlueButton(text: "Confirm", identifier: "Confirm")
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        super.viewDidLoad()
        
        // Allows a tap outside textfields to hide the keyboard.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Add notification so we know when the keyboard is showing or not.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        // Need to setup the view here otherwise going back and forth can go straight to Update Email view logic.
        setupReauthenticateView()
        
        reauthenticateEmailTextField.text = ""
        reauthenticatePasswordTextField.text = ""
        updatePasswordTextField.text = ""
        updateConfirmPasswordTextField.text = ""
        
    }
    
    /// Remove move view up when keyboard appears logic.
    deinit {
        os_log(.info, log: self.app, "Keyboard observers deinitialized")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Action Functions
    
    /// Move keyboard up when needed.
    @objc func keyboardWillShow(notification: NSNotification) {
        os_log(.info, log: self.app, "View moved to accomodate keyboard")
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.cgRectValue.height*0.1
        }
    }
    
    /// Bring keyboard back to normal position.
    @objc func keyboardWillHide(notification: NSNotification) {
        os_log(.info, log: self.app, "View reset while keyboard retracts")
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    /// Reauthenticates user on touch up event on action button.
    @objc func reauthenticateActionButtonPressed() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let email = reauthenticateEmailTextField.text else {
            os_log(.info, log: self.app, "No email present.")
            return
        }
        
        guard let password = reauthenticatePasswordTextField.text else {
            os_log(.info, log: self.app, "No password present.")
            return
        }
        
        hud.textLabel.text = "Reauthenticating..."
        hud.show(in: view, animated: true)
        
        Authentication.reauthenticate(email: email, password: password) { (error) in
            self.hud.dismiss()
            
            if let error = error {
                self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                return
            }
            
            self.setupUpdatePasswordView()
        }
        
    }
    
    /// Update password and return to settings menu  on touch up event on action button.
    @objc func updatePasswordActionButtonPressed() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let password = updatePasswordTextField.text else {
            os_log(.info, log: self.app, "No password present.")
            return
        }
        
        guard let confirmPassword = updateConfirmPasswordTextField.text else {
            os_log(.info, log: self.app, "No password present.")
            return
        }
        
        guard password == confirmPassword else {
            os_log(.info, log: self.app, "Passwords do not match.")
            self.displayAlertForUser(title: "Error", message: "Passwords do not match.")
            return
        }
        
        hud.textLabel.text = "Updating password..."
        hud.show(in: view, animated: true)
        
        Authentication.updatePassword(password: password) { (error) in
            self.hud.dismiss(animated: true)
            
            if let error = error {
                self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                return
            } else {
                os_log(.info, log: self.app, "User has been updated password")
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}
