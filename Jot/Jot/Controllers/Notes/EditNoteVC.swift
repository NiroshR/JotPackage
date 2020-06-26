//
//  EditNoteVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-24.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import os
import UIKit
import WhatsNewKit
import JotModelKit

class EditNoteVC: UIViewController, UITextViewDelegate {
    
    // MARK: -Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    var markdownTextView: MarklightTextView!
    
    var note: Note!
    
    // MARK: -Class Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        super.viewDidLoad()
        
        // Create a note if one is not passed in.
        if note == nil {
            note = Note()
        }
        
        // Add notification so we know when the keyboard is showing or not.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Add the swipe gesture to dismiss the keyboard.
        let swipeDownToDismissKeyboard = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDownToDismissKeyboard.direction = .down
        self.view.addGestureRecognizer(swipeDownToDismissKeyboard)
        
        setupView()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        
        setupNavBar()
        
        // Scroll the text view to the top so the note title is
        // always visible. Otherwise, the note would look to be loaded
        // from the middle.
        markdownTextView.scrollToTop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        // Save the note on exit.
        saveOnExit()
    }
    
    /// Remove move view up when keyboard appears logic.
    deinit {
        os_log(.info, log: self.app, "Keyboard observers deinitialized")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: -Action Functions
    
    /// Move keyboard up when needed.
    @objc func keyboardWillShow(notification: NSNotification) {
        os_log(.info, log: self.app, "View moved to accomodate keyboard")
        
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        var shiftSize = keyboardSize.cgRectValue
        shiftSize = markdownTextView.textView.convert(shiftSize, from:nil)
        markdownTextView.textView.contentInset.bottom = shiftSize.size.height
        markdownTextView.textView.verticalScrollIndicatorInsets.bottom = shiftSize.size.height
        self.view.layoutIfNeeded()
        
    }
    
    /// Bring keyboard back to normal position.
    @objc func keyboardWillHide(notification: NSNotification) {
        os_log(.info, log: self.app, "View reset while keyboard retracts")
        
        let contentInsets = UIEdgeInsets.zero
        markdownTextView.textView.contentInset = contentInsets
        markdownTextView.textView.verticalScrollIndicatorInsets = contentInsets
        markdownTextView.textView.contentInset.top = 15
    }
    
    /// Info button will show the features of Markdown.
    @objc func infoButtonTapped() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        // Create the info items for the WhatsNewView.
        let items = [WhatsNew.Item(title: "Headers", subtitle: "Use '# ' to make a bold statement.", image: nil),
                     WhatsNew.Item(title: "Paragraphs", subtitle: "Seperated by a blank line of course.", image: nil),
                     WhatsNew.Item(title: "Text Formatting", subtitle: "Use symbols to `monospace`, *italic*, and **bold**", image: nil),
                     WhatsNew.Item(title: "Itemized Lists", subtitle: "Jot down your ideas (get it... hehe) using '*'. Or a numbered list starts with '1. something'. Simple.", image: nil),
                     WhatsNew.Item(title: "It is Markdown.", subtitle: "There are plenty of other formatting techniques. Jot uses Markdown to make powerful notes for the average user.", image: nil)
        ]
        
        let theme = WhatsNewViewController.Theme { configuration in
            configuration.backgroundColor = .secondarySystemBackground
            configuration.titleView.titleColor = .label
            configuration.itemsView.titleColor = .secondaryLabel
            configuration.itemsView.subtitleColor = .secondaryLabel
            configuration.completionButton.backgroundColor = .systemBlue
        }
        
        let config = WhatsNewViewController.Configuration(theme: theme)
        
        let whatsNew = WhatsNew(title: "Supercharge your notes.", items: items)
        
        let whatsNewVC = WhatsNewViewController(whatsNew: whatsNew, configuration: config)
        
        self.present(whatsNewVC, animated: true, completion: nil)
        
    }
    
    /// Allow the swipe down gesture to push the keyboard away.
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .down {
            print("Swipe Down")
            self.view.endEditing(true)
        }
    }
    
    // MARK: -Helper Functions
    
    func saveOnExit() {
        let text = markdownTextView.textStorage.string
        
        // If the note is not filled with any content, discard it.
        if note.ID.isEmpty && (text.isEmpty || text == "# " || text == "#") {
            os_log(.info, log: self.app, "No text in note, no need to save")
            return
        }
        
        // Check if the note is the same as what it was before.
        // If so, we can save Firebase writes.
        if note.note == text {
            os_log(.info, log: self.app, "No change in text")
            return
        }
        
        // Get the text and assign it to the note object.
        note.note = text
        
        // If the note is new, add it.
        if note.ID.isEmpty {
            
            note.addData { (success, error) in
                if let error = error {
                    self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                    return
                }
                
                if !success {
                    self.logAndDisplayAlert(app: self.app, log: "Error while saving data", displayAlert: "Try again later")
                    return
                }
                
                os_log(.info, log: self.app, "Document added successfully")
            }
        } else {
            // If there is no content, delete the note.
            if (note.note.isEmpty || note.note == "# " || note.note == "#") {
                note.deleteReminder { (success, error) in
                    if let error = error {
                        self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                        return
                    }
                    
                    if !success {
                        self.logAndDisplayAlert(app: self.app, log: "Error while saving data", displayAlert: "Try again later")
                        return
                    }
                    
                }
                os_log(.info, log: self.app, "Document deleted for note having any text successfully")
                return
            }
            
            // Update the note if it has been edited.
            note.updateData { (success, error) in
                if let error = error {
                    self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                    return
                }
                
                if !success {
                    self.logAndDisplayAlert(app: self.app, log: "Error while saving data", displayAlert: "Try again later")
                    return
                }
                
                os_log(.info, log: self.app, "Document updated successfully")
            }
        }
    }
    
}
