//
//  RemindersVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-20.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import os
import UIKit
import JotModelKit
import JotUIKit

class RemindersVC: UITableViewController, RemindersCellDelegate {
    
    // MARK: -Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    lazy var button = BlueButton(type: .custom)
    
    var reminders: Reminders!
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    lazy var filteredReminders: [Reminder] = []
    
    // MARK: -Class Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        super.viewDidLoad()
        
        // Initialize the reminders array from the Firebase
        // listener, this will actively update the tableview.
        reminders = Reminders()
        
        // Setup the table view and the floating button to the view.
        setupView()
        setupNavBar()
        
        // Load the data from Firebase and this also contains the listeners
        // for reminders to auto-update the table when a reminder is edited.
        reminders.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    // MARK: -Tableview Sections
    
    /// Size of row depending on section.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Number of rows per section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// Number of section to make.
    override func numberOfSections(in tableView: UITableView) -> Int {
        if reminders.remindersArray.count == 0 {
            self.tableView.setEmptyMessage("No Reminders")
        } else {
            self.tableView.restore()
        }
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: backgroundImageGet()))
        
        return (isFiltering ? filteredReminders.count : reminders.remindersArray.count)
    }
    
    /// Reduce the space between the section footers.
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    /// Create a custom footer view to override.
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    /// Reduce the space between the section headers.
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude + 7
    }
    
    /// Create a custom header view to override.
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: -Tableview Rows
    
    /// Set the text for rows.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkMarkCellID", for: indexPath) as! RemindersTableCell
        if isFiltering {
            cell.nameLabel.text = filteredReminders[indexPath.section].title
            cell.secondaryLabel.attributedText = setCellLabel(reminder: filteredReminders[indexPath.section])
            cell.checkBox.on = filteredReminders[indexPath.section].isCompleted
        } else {
            cell.nameLabel.text = reminders.remindersArray[indexPath.section].title
            cell.secondaryLabel.attributedText = setCellLabel(reminder: reminders.remindersArray[indexPath.section])
            cell.checkBox.on = reminders.remindersArray[indexPath.section].isCompleted
        }
        
        // Add delegate to know when the button has been tapped.
        cell.delegate = self
        
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    /// When you select table cell, takes you to appropriate VC.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        // Need to deselect the cell after the tap has ended.
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Push the Edit VC with the note string and ID so we update the note and don't create a new note.
        let editVC = EditReminderVC()
        
        if isFiltering {
            editVC.reminder = filteredReminders[indexPath.section]
        } else {
            editVC.reminder = reminders.remindersArray[indexPath.section]
        }
        
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    /// Enable delete cell by swiping.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Logic of what to do when we try to delete the  cell.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        if (editingStyle == .delete) {
            
            var reminder = reminders.remindersArray[indexPath.section]
            
            if isFiltering {
                reminder = filteredReminders[indexPath.section]
            }
            
            reminder.deleteReminder { (success, error) in
                if let error = error {
                    os_log(.info, log: self.app, "Error removing document: %@", error.localizedDescription)
                    self.displayAlertForUser(title: "Error", message: error.localizedDescription)
                } else if !success {
                    os_log(.info, log: self.app, "Error removing document, success tag marked false")
                    self.displayAlertForUser(title: "Error", message: "Try deleting your reminder again later.")
                } else {
                    os_log(.info, log: self.app, "Document successfully removed! ID: %@", reminder.ID)
                }
            }
        }
    }
    
    // MARK: -Search Functionality
    
    /// Returns true if the text typed in the search bar is empty; otherwise, it returns false.
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Filters reminders based on searchText and puts the results in filteredReminders.
    func filterContentForSearchText(_ searchText: String, category: Reminder? = nil) {
        // You can use this to determine whether a reminder should be part of the
        // search results that the user receives. To do so, you need to return true
        // if you want to include the current reminder in the filtered array or false otherwise.
        filteredReminders = reminders.remindersArray.filter { (reminder: Reminder) -> Bool in
            return reminder.title.lowercased().contains(searchText.lowercased()) ||
                reminder.note.lowercased().contains(searchText.lowercased()) ||
                (reminder.flagged ?? false && String("flagged").contains(searchText.lowercased())) ||
                (reminder.priority == ReminderPriority.High && String("high priority").contains(searchText.lowercased())) ||
                (reminder.priority == ReminderPriority.Medium && String("medium priority").contains(searchText.lowercased())) ||
                (reminder.priority == ReminderPriority.Low && String("low priority").contains(searchText.lowercased()))
        }
        
        tableView.reloadData()
    }
    
    /// Computed property to determine if you are currently filtering results or not.
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: -Action Functions
    
    /// Switches to main application if login successful on touch up event on action button.
    @objc func settingsButtonPressed() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let settingsController = SettingsVC()
        settingsController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: settingsController, action: #selector(settingsController.closeView))
        let settingsNavigationController = UINavigationController(rootViewController: settingsController)
        settingsNavigationController.modalPresentationStyle = .fullScreen
        
        self.present(settingsNavigationController, animated: true, completion: nil)
    }
    
    /// Take user to create a new reminder.
    @objc func addReminderButtonClicked() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        self.navigationController?.pushViewController(EditReminderVC(), animated: true)
    }
    
    // MARK: -Helper Functions
    
    /// Change the reminder completion tag.
    func checkBoxTapped(for cell: RemindersTableCell, isOn: Bool) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            os_log(.info, log: self.app, "Unable to get index path of cell pressed")
            return
        }
        
        // Update the reminder's completed status.
        let reminder = reminders.remindersArray[indexPath.section]
        reminder.isCompleted = isOn
        
        // Send the update to Firebase.
        reminder.updateData { (success, error) in
            if let error = error {
                self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                return
            }
            
            if !success {
                self.logAndDisplayAlert(app: self.app, log: "Error updating reminder after check box tapped, false tag active", displayAlert: "Try again later.")
                return
            }
            
            os_log(.info, log: self.app, "Document updated successfully")
        }
    }
    
}

// https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started

extension RemindersVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            os_log(.error, log: self.app, "Unable to get search bar text.")
            return
        }
        
        filterContentForSearchText(searchText)
    }
}
