//
//  UpdateEmailVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-22.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import JGProgressHUD
import os
import JotUIKit
import UIKit
import JotModelKit

class UpdateEmailVC: UIViewController, UITextFieldDelegate {
    
    // MARK: -Class Variables
    
    lazy var app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    lazy var reauthenticateTitleLabel: UILabel = createTitleLabel(text: "Re-authenticate", numberOfLines: 0)
    
    lazy var reauthenticateEmailTextField: UITextField = createTextField(tag: 0, placeholder: "Your existing email", identifier: "Your existing email", rounded: "Top")
    
    lazy var reauthenticatePasswordTextField = createPasswordTextField(tag: 1, placeholder: "Your existing password", identifier: "Your existing password", rounded: "Bottom")
    
    lazy var reauthenticateActionButton = createSolidBlueButton(text: "Authenticate", identifier: "Authenticate")
    
    lazy var updateEmailTitleLabel: UILabel = createTitleLabel(text: "Update Email", numberOfLines: 0)
    
    lazy var updateEmailTextField: UITextField = createTextField(tag: 0, placeholder: "Your new email", identifier: "Your new email", rounded: "Well-Rounded")
    
    lazy var updateEmailActionButton = createSolidBlueButton(text: "Confirm", identifier: "Confirm")
    
    lazy var hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    // MARK: -Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        super.viewDidLoad()
        
        // Allows a tap outside textfields to hide the keyboard.
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Add notification so we know when the keyboard is showing or not.
        addObservers()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) {
            [weak self] notification in
            
            guard let self = self else {
                return
            }
            
            self.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) {
            [weak self] notification in
            
            guard let self = self else {
                return
            }
            
            self.keyboardWillHide(notification: notification)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        // Need to setup the view here otherwise going back and forth can go straight to Update Email view logic.
        setupReauthenticateView()
        
        reauthenticateEmailTextField.text = ""
        reauthenticatePasswordTextField.text = ""
        updateEmailTextField.text = ""
        
    }
    
    /// Remove move view up when keyboard appears logic.
    deinit {
        os_log(.info, log: app, "Keyboard observers deinitialized")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -Action Functions
    
    /// Move keyboard up when needed.
    @objc func keyboardWillShow(notification: Notification) {
        os_log(.info, log: app, "View moved to accomodate keyboard")
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardSize.cgRectValue.height*0.1
        }
    }
    
    /// Bring keyboard back to normal position.
    @objc func keyboardWillHide(notification: Notification) {
        os_log(.info, log: app, "View reset while keyboard retracts")
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    /// Reauthenticates user on touch up event on action button.
    @objc func reauthenticateActionButtonPressed() {
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let email = reauthenticateEmailTextField.text else {
            os_log(.info, log: app, "No email present.")
            return
        }
        
        guard let password = reauthenticatePasswordTextField.text else {
            os_log(.info, log: app, "No password present.")
            return
        }
        
        hud.textLabel.text = "Reauthenticating..."
        hud.show(in: view, animated: true)
        
        Authentication.reauthenticate(email: email, password: password) {[weak self] (error) in
            guard let self = self else {
                return
            }
            
            self.hud.dismiss()
            
            if let error = error {
                self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                return
            }
            
            self.setupUpdateEmailView()
        }
        
    }
    
    /// Switches to main application if login successful on touch up event on action button.
    @objc func updateEmailActionButtonPressed() {
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let email = updateEmailTextField.text else {
            os_log(.info, log: app, "No email present.")
            return
        }
        
        hud.textLabel.text = "Updating email..."
        hud.show(in: view, animated: true)
        
        Authentication.updateEmail(email: email) {[weak self] (error) in
            guard let self = self else {
                return
            }
            
            self.hud.dismiss(animated: true)
            
            if let error = error {
                self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                return
            } else {
                os_log(.info, log: self.app, "User has been updated email to: %@", email)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
