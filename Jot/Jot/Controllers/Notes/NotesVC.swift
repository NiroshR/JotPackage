//
//  NotesVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-20.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import os
import UIKit
import JotModelKit
import JotUIKit

class NotesVC: UITableViewController {
    
    // MARK: -Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    lazy var button = BlueButton(type: .custom)
    
    var notes: Notes!
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    lazy var filteredNotes: [Note] = []
    
    // MARK: -Class Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        super.viewDidLoad()
        
        notes = Notes()
        
        setupView()
        
        setupNavBar()
        // Load the data from Firebase and this also contains the listeners
        // for notes to auto-update the table when a note is edited.
        notes.loadData {
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
    
    /// Number of rows per section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if notes.notesArray.count == 0 {
            self.tableView.setEmptyMessage("No Notes")
        } else {
            self.tableView.restore()
        }
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: backgroundImageGet()))
        
        return (isFiltering ? filteredNotes.count : notes.notesArray.count)
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
    
    /// Size of row depending on section.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /// Set the text for rows.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "subtitleCellID", for: indexPath)
        cell.backgroundColor = .secondarySystemBackground
        
        switch (indexPath.section) {
        case 0:
            // For more cell details: https://developer.apple.com/documentation/uikit/uitableviewcell
            // Load note text and get rid of Header Markdown
            var noteInstance: Note = notes.notesArray[indexPath.row]
            
            if isFiltering {
                noteInstance = filteredNotes[indexPath.row]
            }
            
            var note: String = noteInstance.note
            note = deletingPrefix(text: note, "# ")
            note = deletingPrefix(text: note, "#")
            
            cell.textLabel?.text = note
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
            
            cell.detailTextLabel?.text = DateModel.formatForLastUpdated(noteInstance.lastUpdated)
            
            cell.detailTextLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        default:
            return cell
        }
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
        
        switch (indexPath.section) {
        case 0:
            // Push the Edit VC with the note string and ID so we update the note and don't create a new note.
            let editVC = EditNoteVC()
            editVC.note = (isFiltering ? filteredNotes[indexPath.row] : notes.notesArray[indexPath.row])
            
            self.navigationController?.pushViewController(editVC, animated: true)
            
        default:
            fatalError("Cell being created in section that doesn't exist")
        }
        
    }
    
    /// Enable delete cell by swiping.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Logic of what to do when we try to delete the  cell.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        // Left swift on cell to delete reminder.
        if (editingStyle == .delete) {
            let note = (isFiltering ? filteredNotes[indexPath.row] : notes.notesArray[indexPath.row])
            
            // Delete the note that was selected.
            note.deleteReminder { (success, error) in
                if let error = error {
                    self.logAndDisplayAlert(app: self.app, log: error.localizedDescription, displayAlert: error.localizedDescription)
                } else if !success {
                    self.logAndDisplayAlert(app: self.app, log: "Error removing document, success tag marked false", displayAlert: "Try deleting your reminder again later.")
                } else {
                    os_log(.info, log: self.app, "Document successfully removed! ID: %@", note.ID)
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
        filteredNotes = notes.notesArray.filter { (note: Note) -> Bool in
            return note.note.lowercased().contains(searchText.lowercased())
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
    
    /// Add note button will show a new edit note view.
    @objc func addNoteButtonClicked() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        self.navigationController?.pushViewController(EditNoteVC(), animated: true)
    }
    
    // MARK: -Helper Functions
    
    // Delete the prefix of a string before showing it to the tableview.
    func deletingPrefix(text: String, _ prefix: String) -> String {
        guard text.hasPrefix(prefix) else { return text }
        return String(text.dropFirst(prefix.count))
    }
    
}

// https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started

extension NotesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            os_log(.error, log: self.app, "Unable to get search bar text.")
            return
        }
        
        filterContentForSearchText(searchText)
    }
}
