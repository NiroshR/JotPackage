//
//  EditReminderVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-27.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import os
import UIKit
import JotModelKit
import JotUIKit

class EditReminderVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: -Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    var reminder: Reminder!
    
    lazy var reminderTitleTextView = createPlaceholderTextView(placeholder: "Title", font: .title2)
    
    lazy var reminderNoteTextView = createPlaceholderTextView(placeholder: "Notes", font: .body, bottomInset: 40)
    
    lazy var reminderDueDateTextField: UITextField = createTextFieldWithLeftImage(placeholder: "Add Due Date", systemImage: "calendar")
    
    lazy var reminderAlertReminderTextField: UITextField = createTextFieldWithLeftImage(placeholder: "Alert Me", systemImage: "bell")
    
    lazy var priorityTextField: UITextField = createTextFieldWithLeftImage(placeholder: "Priority", systemImage: "pin")
    
    lazy var flaggedTextField: UITextField = createTextFieldWithLeftImage(placeholder: "Flagged", systemImage: "flag")
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: -Class Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        super.viewDidLoad()
        
        // If a reminder is not loaded in, create a new reminder.
        if reminder == nil {
            reminder = Reminder()
        }
        
        // Allows a tap outside textfields to hide the keyboard.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Move TextFields to keyboard. Step 1: Add tap gesture to view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        // Setup the edit reminder view.
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Log the operating function.
        os_log(.info, log: app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        
        setupNavBar()
        
        // Move TextFields to keyboard.
        // Step 7: Add observers to receive UIKeyboardWillShow and UIKeyboardWillHide notification.
        addObservers()
        
        // Set up fields of a reminder in the field.
        setReminderInView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Move TextFields to keyboard.
        // Step 8: Remove observers to NOT receive notification when viewcontroller is in the background.
        removeObservers()
        
        // Save the reminder to Firebase.
        saveOnExit()
        reminder = nil
    }
    
    deinit {
        os_log(.info, log: app, "%@", #function)
    }
    
    // MARK: -Keyboard Functionality
    
    /// Move TextFields to keyboard.
    /// Step 2: Add method to handle tap event on the view and dismiss keyboard.
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        // This should hide keyboard for the view.
        view.endEditing(true)
    }
    
    /// Move TextFields to keyboard.
    /// Step 3: Add observers for 'UIKeyboardWillShow' and 'UIKeyboardWillHide' notification.
    func addObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) {
            [weak self] notification in
            
            guard let self = self else {
                return
            }
            
            self.keyboardWillShow(notification: notification)
        }
    }
    
    /// Move TextFields to keyboard.
    /// Step 6: Method to remove observers.
    func removeObservers() {
        for recognizer in view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(recognizer)
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Move TextFields to keyboard.
    /// Step 4: Add method to handle keyboardWillShow notification, we're using this method to adjust scrollview to show hidden textfield under keyboard.
    func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    /// Move TextFields to keyboard.
    /// Step 5: Method to reset scrollview when keyboard is hidden.
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    // MARK: -Action Functions
    
    /// Select the due date from a picker view and set the field text.
    @objc func selectDueDate() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        if let selected = reminder.dueDate, reminderDueDateTextField.text?.isNotEmpty ?? false {
            datePicker.date = selected
        }
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { (make) in
            make.centerX.equalTo(alert.view)
            make.top.equalTo(alert.view).offset(8)
        }
        
        let ok = UIAlertAction(title: "Done", style: .default) { (action) in
            
            let datePicked = datePicker.date
            
            // Set the text for the text field based off due date.
            if datePicked.startOfDay < Date().startOfDay {
                self.reminderDueDateTextField.textColor = .systemRed
                self.reminder.dueDate = datePicked
            } else {
                self.reminderDueDateTextField.textColor = .label
                self.reminder.dueDate = datePicked
            }
            
            self.reminderDueDateTextField.text = "Due "  + DateModel.formatDueDateRelativeAndCustom(datePicked)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// Select the alert time from a picker view and set the field text.
    @objc func selectAlertTime() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        
        if let selected = reminder.alertTime, reminderAlertReminderTextField.text?.isNotEmpty ?? false {
            datePicker.date = selected
        }
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { (make) in
            make.centerX.equalTo(alert.view)
            make.top.equalTo(alert.view).offset(8)
        }
        
        let ok = UIAlertAction(title: "Done", style: .default) { (action) in
            
            let datePicked = datePicker.date
            
            // Set the text for the text field based off alert time.
            if datePicked < Date() {
                self.reminderAlertReminderTextField.textColor = .systemRed
                self.reminder.alertTime = datePicked
            } else {
                self.reminderAlertReminderTextField.textColor = .label
                self.reminder.alertTime = datePicked
            }
            
            self.reminderAlertReminderTextField.text = DateModel.formatAlertTime(datePicked)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// Select the priority of the reminder.
    @objc func selectPriority() {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Priority", preferredStyle: .actionSheet)
        
        // 2
        let nonePriority = UIAlertAction(title: "None", style: .default) { (action) in
            self.reminder.priority = ReminderPriority.None
            self.priorityTextField.text = "None"
        }
        let lowPriority = UIAlertAction(title: "Low", style: .default) { (action) in
            self.reminder.priority = ReminderPriority.Low
            self.priorityTextField.text = "Low"
        }
        
        // 3
        let mediumPriority = UIAlertAction(title: "Medium", style: .default) { (action) in
            self.reminder.priority = ReminderPriority.Medium
            self.priorityTextField.text = "Medium"
        }
        
        let highPriority = UIAlertAction(title: "High", style: .default) { (action) in
            self.reminder.priority = ReminderPriority.High
            self.priorityTextField.text = "High"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // 4
        optionMenu.addAction(nonePriority)
        optionMenu.addAction(lowPriority)
        optionMenu.addAction(mediumPriority)
        optionMenu.addAction(highPriority)
        optionMenu.addAction(cancel)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    /// Select the flag for the reminder.
    @objc func selectFlagged() {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Flag Reminder", preferredStyle: .actionSheet)
        
        // 2
        let noFlag = UIAlertAction(title: "No Flag", style: .default) { (action) in
            self.reminder.flagged = false
            self.flaggedTextField.text = "False"
        }
        let setFlag = UIAlertAction(title: "Set Flag", style: .default) { (action) in
            self.reminder.flagged = true
            self.flaggedTextField.text = "True"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // 4
        optionMenu.addAction(noFlag)
        optionMenu.addAction(setFlag)
        optionMenu.addAction(cancel)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    // MARK: -Helper Functions
    
    /// Setup the fields with the reminder that we start with.
    func setReminderInView() {
        reminderTitleTextView.text = reminder.title
        reminderNoteTextView.text = reminder.note
        
        // If the date is past the start of the day, it will be red.
        if let dueDate = reminder.dueDate {
            
            if dueDate.startOfDay < Date().startOfDay {
                reminderDueDateTextField.textColor = .systemRed
            } else {
                reminderDueDateTextField.textColor = .label
            }
            
            reminderDueDateTextField.text = "Due "  + DateModel.formatDueDateRelativeAndCustom(dueDate)
        }
        
        // If the alert time is past due we mark it with red text.
        if let alertTime = reminder.alertTime {
            
            if alertTime < Date() {
                reminderAlertReminderTextField.textColor = .systemRed
            } else {
                reminderAlertReminderTextField.textColor = .label
            }
            
            reminderAlertReminderTextField.text = DateModel.formatAlertTime(alertTime)
        }
    }
    
    /// Save the reminder to Firebase on exit.
    func saveOnExit() {
        
        _ = { [weak self] in
            guard let strongself = self else { return }
            //...
            // Ensure the title string of reminder is valid.
            guard let titleString = strongself.reminderTitleTextView.text else {
                strongself.logAndDisplayAlert(app: strongself.app, log: "Error grabbing reminder's title string", displayAlert: "Can't save reminder. Try again later")
                return
            }
            strongself.reminder.title = titleString
            
            // Ensure the note string of reminder is valid.
            guard let noteString = strongself.reminderNoteTextView.text else {
                strongself.logAndDisplayAlert(app: strongself.app, log: "Error grabbing reminder's note string", displayAlert: "Can't save reminder. Try again later")
                return
            }
            strongself.reminder.note = noteString
            
            // Ensure the due date string is valid.
            guard let dueDateString = strongself.reminderDueDateTextField.text else {
                strongself.logAndDisplayAlert(app: strongself.app, log: "Error grabbing due date string", displayAlert: "Can't save reminder. Try again later")
                return
            }
            
            // Ensure the alert string is valid.
            guard let alertTimeString = strongself.reminderAlertReminderTextField.text else {
                strongself.logAndDisplayAlert(app: strongself.app, log: "Error grabbing alert time string", displayAlert: "Can't save reminder. Try again later")
                return
            }
            
            // If we have a date stored, but the due date string is empty
            // we need to delete the date because it isn't valid.
            if dueDateString.isEmpty {
                strongself.reminder.dueDate = nil
                os_log(.info, log: strongself.app, "Date was set, but text field has been emptied. Deleting due date.")
            }
            
            // If there is an alert time stored, but the alert string is empty
            // we need to delete the alert time because it isn't valid.
            if alertTimeString.isEmpty {
                strongself.reminder.alertTime = nil
                os_log(.info, log: strongself.app, "Alert time was set, but text field has been emptied. Deleting due alert.")
            }
            
            // If the reminder is new, we create a reminder. If not, we update/delete it as appropriate.
            if strongself.reminder.ID.isEmpty {
                // If there is no title, then we don't save the reminder.
                if titleString.isEmpty {
                    os_log(.info, log: strongself.app, "No text in reminder, no need to save")
                    return
                }
                
                strongself.reminder.addData { (success, error) in
                    if let error = error {
                        strongself.logAndDisplayAlert(app: strongself.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                        return
                    }
                    
                    if !success {
                        strongself.logAndDisplayAlert(app: strongself.app, log: "Error while saving data", displayAlert: "Try again later")
                        return
                    }
                    
                    os_log(.info, log: strongself.app, "Document added successfully")
                }
                
            } else {
                
                // If there is no title and note, then we delete the reminder.
                if titleString.isEmpty && noteString.isEmpty {
                    strongself.reminder.deleteReminder { (success, error) in
                        if let error = error {
                            strongself.logAndDisplayAlert(app: strongself.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                            return
                        }
                        
                        if !success {
                            strongself.logAndDisplayAlert(app: strongself.app, log: "Error while saving data", displayAlert: "Try again later")
                            return
                        }
                        
                    }
                    os_log(.info, log: strongself.app, "Document deleted for note having any text successfully")
                    return
                }
                
                // Update the reminder.
                strongself.reminder.updateData { (success, error) in
                    if let error = error {
                        strongself.logAndDisplayAlert(app: strongself.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                        return
                    }
                    
                    if !success {
                        strongself.logAndDisplayAlert(app: strongself.app, log: "Error while saving data", displayAlert: "Try again later")
                        return
                    }
                    
                    os_log(.info, log: strongself.app, "Document updated successfully")
                }
            }
        }
        
    }
    
}
