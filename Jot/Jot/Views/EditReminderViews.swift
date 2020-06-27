//
//  EditReminderViews.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-28.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit
import JotModelKit

extension EditReminderVC {
    
    func setupViews() {
        // Set background colour.
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.scrollRectToVisible(reminderNoteTextView.frame, animated: true)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(reminderTitleTextView)
        stackView.addArrangedSubview(reminderDueDateTextField)
        stackView.addArrangedSubview(reminderAlertReminderTextField)
        
        // Set the priority of the reminder.
        priorityTextField.clearButtonMode = .never
        stackView.addArrangedSubview(priorityTextField)
        if let priority = reminder.priority {
            priorityTextField.text = priority.rawValue
        } else {
            reminder.priority = ReminderPriority.None
            priorityTextField.text = ReminderPriority.None.rawValue
        }
        
        flaggedTextField.clearButtonMode = .never
        stackView.addArrangedSubview(flaggedTextField)
        if let flagged = reminder.flagged {
            flaggedTextField.text = (flagged ? "True" : "False")
        } else {
            flaggedTextField.text = "False"
        }
        
        stackView.addArrangedSubview(reminderNoteTextView)
        
        let dueDateTap = UITapGestureRecognizer(target: self, action: #selector(selectDueDate))
        dueDateTap.delegate = self
        reminderDueDateTextField.addGestureRecognizer(dueDateTap)
        
        let alertTimeTap = UITapGestureRecognizer(target: self, action: #selector(selectAlertTime))
        alertTimeTap.delegate = self
        reminderAlertReminderTextField.addGestureRecognizer(alertTimeTap)
        
        let priorityTap = UITapGestureRecognizer(target: self, action: #selector(selectPriority))
        priorityTap.delegate = self
        priorityTextField.addGestureRecognizer(priorityTap)
        
        let flaggedTap = UITapGestureRecognizer(target: self, action: #selector(selectFlagged))
        flaggedTap.delegate = self
        flaggedTextField.addGestureRecognizer(flaggedTap)
        
        stackView.setCustomSpacing(20, after: reminderTitleTextView)
        stackView.setCustomSpacing(5, after: reminderDueDateTextField)
        stackView.setCustomSpacing(5, after: reminderAlertReminderTextField)
        stackView.setCustomSpacing(5, after: priorityTextField)
        stackView.setCustomSpacing(5, after: flaggedTextField)
        stackView.setCustomSpacing(5, after: reminderNoteTextView)
        
        setupLayout()
    }
    
    func setupLayout() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        // because: "Constraints between the height, width, or centers attach to the scroll view’s frame." -
        // https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/WorkingwithScrollViews.html
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    /// Setup navigation bar for the view.
    func setupNavBar() {
        // Set clear navigation bar.
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBarColor(UIColor.clear)
        
    }
    
}
