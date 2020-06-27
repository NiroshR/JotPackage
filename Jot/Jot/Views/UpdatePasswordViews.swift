//
//  UpdatePasswordViews.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-29.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import SnapKit
import UIKit

extension UpdatePasswordVC {
    
    /// Adds subviews and arranged UI components of view for reauthenticate view.
    func setupReauthenticateView() {
        
        // Set the background colour to the user default.
        view.backgroundColor = .systemBackground
        
        // Remove any existing subviews.
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        view.addSubview(reauthenticatePasswordTextField)
        reauthenticatePasswordTextField.delegate = self
        reauthenticatePasswordTextField.returnKeyType = UIReturnKeyType.done
        reauthenticatePasswordTextField.keyboardType = .asciiCapable
        reauthenticatePasswordTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(view)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
            
        }
        
        view.addSubview(reauthenticateEmailTextField)
        reauthenticateEmailTextField.delegate = self
        reauthenticateEmailTextField.returnKeyType = UIReturnKeyType.next
        reauthenticateEmailTextField.keyboardType = .emailAddress
        reauthenticateEmailTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(reauthenticatePasswordTextField.snp.top).offset(-2.5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(reauthenticatePasswordTextField.snp.height)
            
        }
        
        
        view.addSubview(reauthenticateTitleLabel)
        reauthenticateTitleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(50).priority(.required)
            make.bottomMargin.equalTo(reauthenticateEmailTextField.snp.topMargin).priority(.required)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(reauthenticateActionButton)
        reauthenticateActionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(reauthenticatePasswordTextField.snp.bottom).offset(15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(reauthenticatePasswordTextField.snp.height)
            
        }
        reauthenticateActionButton.addTarget(self, action: #selector(reauthenticateActionButtonPressed),
                                             for: .touchUpInside)
    }
    
    /// Adds subviews and arranged UI components of view for update password view.
    func setupUpdatePasswordView() {
        
        // Set the background colour to the user default.
        view.backgroundColor = .systemBackground
        
        // Remove any existing subviews.
        for view in view.subviews {
            view.removeFromSuperview()
        }
        
        view.addSubview(updateConfirmPasswordTextField)
        updateConfirmPasswordTextField.delegate = self
        updateConfirmPasswordTextField.returnKeyType = UIReturnKeyType.done
        updateConfirmPasswordTextField.keyboardType = .asciiCapable
        updateConfirmPasswordTextField.snp.makeConstraints { (make) in
            make.centerY.centerX.equalTo(view)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.greaterThanOrEqualTo(40)
            
        }
        
        view.addSubview(updatePasswordTextField)
        updatePasswordTextField.delegate = self
        updatePasswordTextField.returnKeyType = UIReturnKeyType.next
        updatePasswordTextField.keyboardType = .asciiCapable
        updatePasswordTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(updateConfirmPasswordTextField.snp.top).offset(-2.5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(updateConfirmPasswordTextField.snp.height)
            
        }
        
        view.addSubview(updatePasswordTitleLabel)
        updatePasswordTitleLabel.snp.makeConstraints { (make) in
            make.topMargin.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(50).priority(.required)
            make.bottomMargin.equalTo(updatePasswordTextField.snp.topMargin).priority(.required)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(12)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-12)
            make.centerX.equalTo(view)
        }
        
        view.addSubview(updatePasswordActionButton)
        updatePasswordActionButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(updateConfirmPasswordTextField.snp.bottom).offset(15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(40)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-40)
            make.height.equalTo(updateConfirmPasswordTextField.snp.height)
            
        }
        updatePasswordActionButton.addTarget(self, action: #selector(updatePasswordActionButtonPressed),
                                             for: .touchUpInside)
    }
    
}
