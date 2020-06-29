//
//  AuthenticationVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-20.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import JotModelKit
import JotUIKit
import JGProgressHUD
import os
import UIKit
import WhatsNewKit
import FirebaseAuth

class AuthenticationVC: UIViewController, UITextFieldDelegate {
    
    // MARK: -Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    var loginTitleLabel: UILabel = createTitleLabel(text: "Jot", numberOfLines: 0)
    
    var emailTextField: UITextField = createTextField(tag: 0, placeholder: "Your email", identifier: "Your email", rounded: "Top")
    
    var loginPasswordTextField = createPasswordTextField(tag: 1, placeholder: "Your password", identifier: "Your password", rounded: "Bottom")
    
    var loginActionButton = createSolidBlueButton(text: "Sign in", identifier: "Sign in")
    
    var loginSwitchButton: UIButton = createBlueButton(text: "Create an account", identifier: "Create an account")
    
    var loginForgotPasswordButton: UIButton = createBlueButton(text: "Forgot password", identifier: "Forgot password")
    
    var registerTitleLabel: UILabel = createTitleLabel(text: "Create an Account", numberOfLines: 0)
    
    var registerPasswordTextField = createPasswordTextField(tag: 1, placeholder: "Your password", identifier: "Your password", rounded: "Middle")
    
    var registerConfirmPasswordField = createPasswordTextField(tag: 2, placeholder: "Confirm password", identifier: "Confirm password", rounded: "Bottom")
    
    var registerActionButton = createSolidBlueButton(text: "Register", identifier: "Register")
    
    var registerSwitchButton: UIButton = createBlueButton(text: "Already have an account?", identifier: "Already have an account?")
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    var keyboardFactor: CGFloat = 0.0
    
    // MARK: -Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        super.viewDidLoad()
        
        if !firstRunCheck()  {
            setupRegisterView()
            splashScreen()
        } else {
            setupLoginView()
        }
        
        // Add notification so we know when the keyboard is showing or not.
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        super.viewWillAppear(animated)
        
        // Hide the tab bar navigation bar so we don't have to do it in every
        // view controller that we show in the tab bar controller.
        navigationController?.navigationBar.isHidden = true
        
        // If a user is logged in or created, the view will be dismissed.
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.hud.dismiss(animated: true)
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
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
        
        // Allows a tap outside textfields to hide the keyboard.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func removeObservers() {
        for recognizer in view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(recognizer)
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Remove move view up when keyboard appears logic.
    deinit {
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        removeObservers()
    }
    
    // MARK: -Action Functions
    
    /// Move keyboard up when needed.
    @objc func keyboardWillShow(notification: Notification) {
        os_log(.info, log: self.app, "View moved to accomodate keyboard")
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.cgRectValue.height * keyboardFactor
        }
    }
    
    /// Bring keyboard back to normal position.
    @objc func keyboardWillHide(notification: Notification) {
        os_log(.info, log: self.app, "View reset while keyboard retracts")
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    /// Switches to Register view on touch up event of switch button.
    @objc func switchToRegister() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Switch to the Register view, setting the email field
        // as the text currently in the credentialsTextField.
        setupRegisterView()
        
    }
    
    /// Switches to Login view on touch up event of switch button.
    @objc func switchToLogin() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        setupLoginView()
    }
    
    /// Switches to main application if login successful on touch up event on action button.
    @objc func loginActionButtonPressed() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let email = emailTextField.text else {
            os_log(.info, log: self.app, "No email present.")
            return
        }
        
        guard let password = loginPasswordTextField.text else {
            os_log(.info, log: self.app, "No password present.")
            return
        }
        
        // Show progress HUD to user.
        hud.textLabel.text = "Signing in..."
        hud.show(in: view, animated: true)
        
        Authentication.login(email: email, password: password) { (error) in
            if let error = error {
                self.hud.dismiss(animated: true)
                self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                return
            }
        }
    }
    
    /// Switches to main application if register successful on touch up event on action button.
    @objc func registerActionButtonPressed() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let email = emailTextField.text else {
            os_log(.info, log: self.app, "No email present.")
            return
        }
        
        guard let password = registerPasswordTextField.text else {
            os_log(.info, log: self.app, "No password present.")
            return
        }
        
        guard let confirmPassword = registerConfirmPasswordField.text else {
            os_log(.info, log: self.app, "No password present.")
            return
        }
        
        guard password == confirmPassword else {
            os_log(.info, log: self.app, "Passwords do not match.")
            self.displayAlertForUser(title: "Error", message: "Passwords do not match.")
            return
        }
        
        // Show progress HUD to user.
        hud.textLabel.text = "Registering you now..."
        hud.show(in: view, animated: true)
        
        Authentication.register(email: email, password: password) { (error) in
            if let error = error {
                self.hud.dismiss(animated: true)
                self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                return
            }
        }
    }
    
    /// Logic for password reset for a user
    @objc func resetPassword() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
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
        
        // Once the submit button is pressed, the password and email fields are processed.
        let submitAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned ac] _ in
            
            guard let email = ac.textFields?[0].text else {
                os_log(.info, log: self.app, "No email present.")
                return
            }
            
            self.hud.textLabel.text = "Sending password reset email..."
            self.hud.show(in: self.view, animated: true)
            
            Authentication.passwordReset(email: email) { (error) in
                self.hud.dismiss(animated: true)
                
                if let error = error {
                    self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                } else {
                    self.displayAlertForUser(title: "Password Reset", message: "Email sent to \(email) to reset account password")
                }
            }
            
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in}))
        self.present(ac, animated: true)
    }
    
    // MARK: -Splash Screen
    
    func splashScreen() {
        let items = [WhatsNew.Item(title: "Reminders", subtitle: "Easy method to keep tabs on the simple things that matter",
                                   image: UIImage(systemName: "checkmark.square")),
                     WhatsNew.Item(title: "Notes", subtitle: "Jot down whatever keeps you up at night, or what you need to work on the next day.",
                                   image: UIImage(systemName: "list.bullet"))
        ]
        
        let theme = WhatsNewViewController.Theme { configuration in
            configuration.apply(animation: .fade)
            configuration.backgroundColor = .secondarySystemBackground
            configuration.titleView.titleColor = .label
            configuration.itemsView.titleColor = .secondaryLabel
            configuration.itemsView.subtitleColor = .secondaryLabel
            configuration.completionButton.backgroundColor = .systemBlue
        }
        
        let config = WhatsNewViewController.Configuration(theme: theme)
        
        let whatsNew = WhatsNew(title: "Jot.\nYour new reminders and notes app.", items: items)
        
        let keyValueVersionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard)
        
        let whatsNewVC = WhatsNewViewController(whatsNew: whatsNew, configuration: config, versionStore: keyValueVersionStore)
        
        if let vc = whatsNewVC {
            os_log(.info, log: self.app, "Splash screen being presented")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
