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
        view.backgroundColor = .systemBackground
        keyboardFactor = 0.1
        
        // Remove any existing subviews.
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        
        view.addSubview(loginPasswordTextField)
        loginPasswordTextField.delegate = self
        loginPasswordTextField.returnKeyType = UIReturnKeyType.done
        loginPasswordTextField.keyboardType = .asciiCapable
        loginPasswordTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(view)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
            
        }
        
        view.addSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.returnKeyType = UIReturnKeyType.next
        emailTextField.keyboardType = .emailAddress
        emailTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginPasswordTextField.snp.top).offset(-2.5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(loginPasswordTextField.snp.height)
            
        }
        
        
        view.addSubview(loginTitleLabel)
        loginTitleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(50).priority(.required)
            make.bottomMargin.equalTo(emailTextField.snp.topMargin).priority(.required)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(loginActionButton)
        loginActionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(loginPasswordTextField.snp.bottom).offset(15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(loginPasswordTextField.snp.height)
            
        }
        loginActionButton.addTarget(self, action: #selector(loginActionButtonPressed),
                                    for: .touchUpInside)
        
        view.addSubview(loginSwitchButton)
        loginSwitchButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.topMargin.equalTo(loginActionButton.snp.bottomMargin).offset(30)
            make.width.greaterThanOrEqualTo(250)
            make.height.greaterThanOrEqualTo(30)
        }
        loginSwitchButton.addTarget(self, action: #selector(switchToRegister),
                                    for: .touchUpInside)
        
        view.addSubview(loginForgotPasswordButton)
        loginForgotPasswordButton.setTitleColor(UIColor.systemRed, for: .normal)
        loginForgotPasswordButton.setTitleColor(UIColor.systemRed.withAlphaComponent(0.5), for: .highlighted)
        loginForgotPasswordButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.topMargin.equalTo(loginSwitchButton.snp.bottomMargin).offset(20)
            make.width.greaterThanOrEqualTo(250)
            make.height.greaterThanOrEqualTo(30)
        }
        loginForgotPasswordButton.addTarget(self, action: #selector(resetPassword),
                                            for: .touchUpInside)
        
    }
    
    /// Adds subviews and arranged UI components of view.
    func setupRegisterView() {
        
        // Set the background colour to the user default.
        view.backgroundColor = .systemBackground
        keyboardFactor = 0.25
        
        // Remove any existing subviews.
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        // Set background colour to user settings
        view.backgroundColor = .systemBackground
        
        view.addSubview(registerPasswordTextField)
        registerPasswordTextField.delegate = self
        registerPasswordTextField.returnKeyType = UIReturnKeyType.next
        registerPasswordTextField.keyboardType = .asciiCapable
        registerPasswordTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(view)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
        }
        
        view.addSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.returnKeyType = UIReturnKeyType.next
        emailTextField.keyboardType = .emailAddress
        emailTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(registerPasswordTextField.snp.top).offset(-2.5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(registerPasswordTextField.snp.height)
        }
        
        view.addSubview(registerConfirmPasswordField)
        registerConfirmPasswordField.delegate = self
        registerConfirmPasswordField.returnKeyType = UIReturnKeyType.done
        registerConfirmPasswordField.keyboardType = .asciiCapable
        registerConfirmPasswordField.snp.makeConstraints { (make) in
            make.top.equalTo(registerPasswordTextField.snp.bottom).offset(2.5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(registerPasswordTextField.snp.height)
        }
        
        view.addSubview(registerTitleLabel)
        registerTitleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(50).priority(.required)
            make.bottomMargin.equalTo(emailTextField.snp.topMargin).priority(.required)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(registerActionButton)
        registerActionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(registerConfirmPasswordField.snp.bottom).offset(15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(registerPasswordTextField.snp.height)
        }
        registerActionButton.addTarget(self, action: #selector(registerActionButtonPressed),
                                       for: .touchUpInside)
        
        view.addSubview(registerSwitchButton)
        registerSwitchButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.topMargin.equalTo(registerActionButton.snp.bottomMargin).offset(30)
            make.width.greaterThanOrEqualTo(250)
            make.height.greaterThanOrEqualTo(30)
        }
        registerSwitchButton.addTarget(self, action: #selector(switchToLogin),
                                       for: .touchUpInside)
    }
    
}
