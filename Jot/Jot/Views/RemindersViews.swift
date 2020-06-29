//
//  RemindersViews.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-29.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit
import JotUIKit
import JotModelKit

extension RemindersVC {
    
    /// Organize UI componenets of this view.
    func setupView() {
        // Setup the navigation bar item for settings.
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                     style: .plain, target: self, action: #selector(settingsButtonPressed))
        navigationItem.rightBarButtonItem = button
        
        // Add our search bar at the top of the view. Non-persistent behaviour.
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Reminders"
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.searchTextField.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Group the table view by section. This gets rid of blank horizontal lines where a cell would be.
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        
        //Registers a class for use in creating new table cells.
        tableView.register(RemindersTableCell.self, forCellReuseIdentifier: "checkMarkCellID")
        
        // Load the add reminder float button.
        loadFloatButton()
    }
    
    /// Place circular add note button ontop of tableview.
    func loadFloatButton() {
        button.backgroundColor = .systemBlue
        button.setTitle("+", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 34)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 3, right: 0)
        
        view.addSubview(button)
        button.snp.makeConstraints {(make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(button.snp.height)
        }
        
        button.addTarget(self, action: #selector(addReminderButtonClicked),
                         for: .touchUpInside)
    }
    
    /// Setup navigation bar for the view.
    func setupNavBar() {
        // Set navigation bar title.
        title = "Reminders"
        
        // Set clear navigation bar.
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBarColor(UIColor.systemBackground.withAlphaComponent(0.9))
    }
    
    /// Set the color of text based on due date or alert in future or past.
    func setCellLabel(reminder: Reminder) -> NSMutableAttributedString {
        let label: NSMutableAttributedString = NSMutableAttributedString()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemRed,
        ]
        
        if let flagged = reminder.flagged {
            if flagged {
                label.append(NSAttributedString(string: "\u{1F6A9}"))
            }
        }
        
        if let priority = reminder.priority {
            let buffer = " • "
            var string = ""
            
            switch priority {
            case .High:
                string = "!!!"
            case .Medium:
                string = "!!"
            case .Low:
                string = "!"
            case .None:
                string = ""
            }
            
            if label.string.isNotEmpty {
                label.append(NSAttributedString(string: buffer))
            }
            
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            
            label.append(attributedString)
        }
        
        if let dueDate = reminder.dueDate {
            let buffer = " • "
            let string = "Due " + DateModel.formatDueDateRelativeAndCustom(dueDate)
            
            if label.string.isNotEmpty {
                label.append(NSAttributedString(string: buffer))
            }
            
            var attributedString = NSAttributedString(string: string, attributes: [:])
            
            if dueDate.startOfDay < Date() {
                attributedString = NSAttributedString(string: string, attributes: attributes)
            }
            
            label.append(attributedString)
        }
        
        if let alert = reminder.alertTime {
            let buffer = " • "
            let string = "\u{23F0} Alert"
            
            if label.string.isNotEmpty {
                label.append(NSAttributedString(string: buffer))
            }
            
            var attributedString = NSAttributedString(string: string, attributes: [:])
            
            if alert < Date() {
                attributedString = NSAttributedString(string: string, attributes: attributes)
            }
            
            label.append(attributedString)
        }
        
        
        if reminder.note.isNotEmpty {
            let buffer = " • "
            let string = "\u{1F4DD} Note"
            
            if label.string.isNotEmpty {
                label.append(NSAttributedString(string: buffer))
            }
            
            label.append(NSAttributedString(string: string))
        }
        
        return label
    }
    
}
