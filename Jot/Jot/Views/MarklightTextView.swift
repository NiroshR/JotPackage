//
//  MarklightTextView.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-03.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit
import JotUIKit

class MarklightTextView {
    
    // MARK: -Class Variables
    
    lazy var textView = UITextView()
    
    lazy var textStorage = createMarklightTextStorage()
    
    lazy var layoutManager = NSLayoutManager()
    
    // MARK: -Class Init
    
    init(_ parentVC: UITextViewDelegate, text: String) {
        layoutManager.textStorage = textStorage
        
        textView.isScrollEnabled = true
        textView.keyboardDismissMode = .interactive
        textView.isUserInteractionEnabled = true
        textView.delegate = parentVC
        textView.contentInset.top = 15
        textView.text = text
        
        // Append the loaded string to the NSTextStorage.
        let attributedString = NSAttributedString(string: text )
        textView.attributedText = attributedString
        textStorage.append(attributedString)
        textStorage.addLayoutManager(textView.layoutManager)
        textStorage.addLayoutManager(layoutManager)
    }
    
    // MARK: -Helper Functions
    
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -textView.contentInset.top)
        textView.setContentOffset(desiredOffset, animated: true)
    }
    
    private func createMarklightTextStorage() -> MarklightTextStorage {
        let textStorage = MarklightTextStorage()
        
        // Set the formatting style of the Markdown.
        textStorage.marklightTextProcessor.codeColor = UIColor.systemGreen
        textStorage.marklightTextProcessor.quoteColor = UIColor.systemIndigo
        textStorage.marklightTextProcessor.syntaxColor = UIColor.systemPink
        textStorage.marklightTextProcessor.fontTextStyle = UIFont.TextStyle.body.rawValue
        textStorage.marklightTextProcessor.hideSyntax = true
        
        return textStorage
    }
    
}
