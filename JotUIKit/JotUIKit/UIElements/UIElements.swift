//
//  UIElements.swift
//  JotUIKit
//
//  Created by Nirosh Ratnarajah on 2020-06-23.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit

public class BlueButton: UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.systemBlue.withAlphaComponent(0.85) : UIColor.systemBlue
        }
    }
}

// MARK: Labels

/// Creates a title label for a view.
/// - Parameter text: Text to be set as title string.
/// - Parameter numberOfLines: Set to 0 if the text should wrap around automatically.
/// - Returns: Title label for UIView.
public func createTitleLabel(text: String, numberOfLines: Int) -> UILabel {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    label.textColor = .label
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = numberOfLines
    label.textAlignment = .center
    label.text = text
    return label
}

// MARK: Textfields

/// Create a textfield with variable corner rounding.
/// - Parameter tag: Textfield's tag to allow keyboard 'next' button to shift first responder to next text field.
/// - Parameter placeholder: Placeholder text when text field is empty.
/// - Parameter identifier: Accessibility identifier string for captioning textfields.
/// - Parameter rounded: String to identify what kind of rounding the textfield should return with.
///     + "Well-Rounded": All corners of text field are rounded.
///     + "Top": Top corners of text field are rounded.
///     + "Bottom": Bottom corners of text field are rounded.
///     + "None": No corners are rounded.
/// - Returns: A textfield with with no text auto correcting.
public func createTextField(tag: Int, placeholder: String, identifier: String, rounded: String) -> UITextField {
    let textField = UITextField()
    textField.font = UIFont.preferredFont(forTextStyle: .body)
    textField.autocorrectionType = .no
    textField.autocapitalizationType = .none
    textField.spellCheckingType = .no
    textField.layer.masksToBounds = true
    textField.layer.cornerRadius = 7
    textField.tag = tag
    textField.leftViewMode = .always
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
    
    if rounded == "Top" {
        textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    } else if rounded == "Bottom" {
        textField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    } else if rounded == "Middle" {
        textField.layer.cornerRadius = 0
        textField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    textField.backgroundColor = .secondarySystemGroupedBackground
    textField.adjustsFontForContentSizeCategory = true
    textField.textColor = .label
    textField.accessibilityIdentifier = identifier
    textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
    return textField
}

/// Create a password textfield with variable corner rounding.
/// - Parameter tag: Textfield's tag to allow keyboard 'next' button to shift first responder to next text field.
/// - Parameter placeholder: Placeholder text when text field is empty.
/// - Parameter identifier: Accessibility identifier string for captioning textfields.
/// - Parameter rounded: String to identify what kind of rounding the textfield should return with.
///     + "Well-Rounded": All corners of text field are rounded.
///     + "Top": Top corners of text field are rounded.
///     + "Bottom": Bottom corners of text field are rounded.
///     + "None": No corners are rounded.
/// - Returns: A password textfield using the PasswordTextField library.
public func createPasswordTextField(tag: Int, placeholder: String, identifier: String, rounded: String) -> PasswordTextField {
    let passwordTextField = PasswordTextField()
    passwordTextField.font = UIFont.preferredFont(forTextStyle: .body)
    passwordTextField.autocorrectionType = .no
    passwordTextField.autocapitalizationType = .none
    passwordTextField.spellCheckingType = .no
    passwordTextField.layer.masksToBounds = true
    passwordTextField.isSecureTextEntry = true
    passwordTextField.layer.cornerRadius = 7
    passwordTextField.tag = tag
    passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: passwordTextField.frame.height))
    passwordTextField.leftViewMode = .always
    
    if rounded == "Top" {
        passwordTextField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    } else if rounded == "Bottom" {
        passwordTextField.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    } else if rounded == "Middle" {
        passwordTextField.layer.cornerRadius = 0
        passwordTextField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    passwordTextField.backgroundColor = .secondarySystemGroupedBackground
    passwordTextField.adjustsFontForContentSizeCategory = true
    passwordTextField.textColor = .label
    passwordTextField.accessibilityIdentifier = identifier
    passwordTextField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
    return passwordTextField
}

// MARK: Buttons

/// Creates a solid blue button with white text.
/// - Parameter text: Text to be placed in center of button.
/// - Parameter identifier: Accessibility identifier string for captioning button.
/// - Returns: A solid blue button to be used for big actions.
public func createSolidBlueButton(text: String, identifier: String) -> BlueButton {
    let button = BlueButton()
    button.backgroundColor = UIColor.systemBlue
    
    button.layer.cornerRadius = 7
    button.clipsToBounds = true
    button.isUserInteractionEnabled = true
    button.accessibilityIdentifier = identifier
    
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
    button.accessibilityIdentifier = identifier
    button.setTitle(text, for: .normal)
    button.titleLabel?.adjustsFontForContentSizeCategory = true
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
    button.titleLabel?.textAlignment = NSTextAlignment.center
    button.setTitleColor(UIColor.white, for: .normal)
    button.setTitleColor(UIColor.white.withAlphaComponent(0.9), for: .highlighted)
    button.isUserInteractionEnabled = true
    return button
}

/// Creates a blue text button.
/// - Parameter text: Text to be placed in center of button.
/// - Parameter identifier: Accessibility identifier string for captioning button.
/// - Returns: A blue button with no background colour.
public func createBlueButton(text: String, identifier: String) -> UIButton {
    let button = UIButton()
    button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
    button.accessibilityIdentifier = identifier
    button.setTitle(text, for: .normal)
    button.titleLabel?.adjustsFontForContentSizeCategory = true
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping;
    button.titleLabel?.textAlignment = NSTextAlignment.center
    button.setTitleColor(UIColor.systemBlue, for: .normal)
    button.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.5), for: .highlighted)
    button.isUserInteractionEnabled = true
    return button
}

/// Creates a textview with a placeholder.
/// - Parameter placeholder: Text to be used as the placeholder.
/// - Parameter font: UIFont style to be used as the placeholder and main text font.
/// - Parameter bottomInset: Extra space placed at bottom of text view.
/// - Returns: A textview with the placeholder and font requested, with a bottom inset.
public func createPlaceholderTextView(placeholder: String, font: UIFont.TextStyle, bottomInset: CGFloat = 10) -> KMPlaceholderTextView {
    let textView = KMPlaceholderTextView()
    textView.isScrollEnabled = false
    textView.backgroundColor = .secondarySystemBackground
    textView.keyboardDismissMode = .interactive
    textView.isUserInteractionEnabled = true
    textView.adjustsFontForContentSizeCategory = true
    textView.font = UIFont.preferredFont(forTextStyle: font)
    textView.placeholderFont = UIFont.preferredFont(forTextStyle: font)
    textView.placeholder = placeholder
    textView.placeholderColor = .secondaryLabel
    textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: bottomInset, right: 10)
    textView.layer.cornerRadius = 7
    return textView
}

/// Creates a textfield with a left image view.
/// - Parameter placeholder: Text to be used as the placeholder.
/// - Parameter systemImage: String of the system name image to use for the left image.
/// - Returns: A textfield with the placeholder and image specified.
public func createTextFieldWithLeftImage(placeholder: String, systemImage: String) -> UITextField {
    let textField = UITextField()
    textField.font = UIFont.preferredFont(forTextStyle: .body)
    textField.layer.masksToBounds = true
    textField.layer.cornerRadius = 7
    textField.clearButtonMode = .always
    
    textField.backgroundColor = .secondarySystemBackground
    textField.adjustsFontForContentSizeCategory = true
    textField.textColor = .label
    textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
    
    let imageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 24.0, height: 24.0))
    let image = UIImage(systemName: systemImage)
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .secondaryLabel
    
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    view.addSubview(imageView)
    textField.leftViewMode = UITextField.ViewMode.always
    textField.leftView = view
    
    let height = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40.0)
    textField.addConstraint(height)
    
    return textField
}
