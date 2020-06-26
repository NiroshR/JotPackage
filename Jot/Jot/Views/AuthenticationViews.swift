//
//  AuthenticationViews.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-29.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit
import SnapKit

extension AuthenticationVC {
        
    /// Adds subviews and arranged UI components of view.
    func setupLoginView() {
        
        // Set the background colour to the user default.
        self.view.backgroundColor = .systemBackground
        keyboardFactor = 0.1
        
        // Remove any existing subviews.
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        
        self.view.addSubview(loginPasswordTextField)
        loginPasswordTextField.delegate = self
        loginPasswordTextField.returnKeyType = UIReturnKeyType.done
        loginPasswordTextField.keyboardType = .asciiCapable
        loginPasswordTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
            
        }
        
        self.view.addSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.returnKeyType = UIReturnKeyType.next
        emailTextField.keyboardType = .emailAddress
        emailTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginPasswordTextField.snp.top).offset(-2.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(loginPasswordTextField.snp.height)
            
        }
        
        
        self.view.addSubview(loginTitleLabel)
        loginTitleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(50).priority(.required)
            make.bottomMargin.equalTo(emailTextField.snp.topMargin).priority(.required)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(loginActionButton)
        loginActionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(loginPasswordTextField.snp.bottom).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(loginPasswordTextField.snp.height)
            
        }
        loginActionButton.addTarget(self, action: #selector(self.loginActionButtonPressed),
                                    for: .touchUpInside)
        
        self.view.addSubview(loginSwitchButton)
        loginSwitchButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.topMargin.equalTo(loginActionButton.snp.bottomMargin).offset(30)
            make.width.greaterThanOrEqualTo(250)
            make.height.greaterThanOrEqualTo(30)
        }
        loginSwitchButton.addTarget(self, action: #selector(self.switchToRegister),
                                    for: .touchUpInside)
        
        self.view.addSubview(loginForgotPasswordButton)
        loginForgotPasswordButton.setTitleColor(UIColor.systemRed, for: .normal)
        loginForgotPasswordButton.setTitleColor(UIColor.systemRed.withAlphaComponent(0.5), for: .highlighted)
        loginForgotPasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.topMargin.equalTo(loginSwitchButton.snp.bottomMargin).offset(20)
            make.width.greaterThanOrEqualTo(250)
            make.height.greaterThanOrEqualTo(30)
        }
        loginForgotPasswordButton.addTarget(self, action: #selector(self.resetPassword),
                                    for: .touchUpInside)
        
    }
    
    /// Adds subviews and arranged UI components of view.
    func setupRegisterView() {
        
        // Set the background colour to the user default.
        self.view.backgroundColor = .systemBackground
        keyboardFactor = 0.25
        
        // Remove any existing subviews.
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        // Set background colour to user settings
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(registerPasswordTextField)
        registerPasswordTextField.delegate = self
        registerPasswordTextField.returnKeyType = UIReturnKeyType.next
        registerPasswordTextField.keyboardType = .asciiCapable
        registerPasswordTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(self.view)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
        }
        
        self.view.addSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.returnKeyType = UIReturnKeyType.next
        emailTextField.keyboardType = .emailAddress
        emailTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(registerPasswordTextField.snp.top).offset(-2.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(registerPasswordTextField.snp.height)
        }
        
        self.view.addSubview(registerConfirmPasswordField)
        registerConfirmPasswordField.delegate = self
        registerConfirmPasswordField.returnKeyType = UIReturnKeyType.done
        registerConfirmPasswordField.keyboardType = .asciiCapable
        registerConfirmPasswordField.snp.makeConstraints { (make) in
            make.top.equalTo(registerPasswordTextField.snp.bottom).offset(2.5)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(registerPasswordTextField.snp.height)
        }
        
        self.view.addSubview(registerTitleLabel)
        registerTitleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(50).priority(.required)
            make.bottomMargin.equalTo(emailTextField.snp.topMargin).priority(.required)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(self.view)
        }
        
        self.view.addSubview(registerActionButton)
        registerActionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(registerConfirmPasswordField.snp.bottom).offset(15)
            make.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(registerPasswordTextField.snp.height)
        }
        registerActionButton.addTarget(self, action: #selector(self.registerActionButtonPressed),
                                       for: .touchUpInside)
        
        self.view.addSubview(registerSwitchButton)
        registerSwitchButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.topMargin.equalTo(registerActionButton.snp.bottomMargin).offset(30)
            make.width.greaterThanOrEqualTo(250)
            make.height.greaterThanOrEqualTo(30)
        }
        registerSwitchButton.addTarget(self, action: #selector(self.switchToLogin),
                                       for: .touchUpInside)
    }
    
    
}
