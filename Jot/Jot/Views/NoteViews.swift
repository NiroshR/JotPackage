//
//  NoteViews.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-29.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit
import JotUIKit

extension NotesVC {
    
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
        searchController.searchBar.placeholder = "Search Notes"
        searchController.searchBar.backgroundColor = UIColor.clear
        searchController.searchBar.searchTextField.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.5)
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Group the table view by section. This gets rid of blank horizontal lines where a cell would be.
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        
        //Registers a class for use in creating new table cells.
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "subtitleCellID")
        
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
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.height.greaterThanOrEqualTo(40)
            make.width.greaterThanOrEqualTo(button.snp.height)
        }
        
        button.addTarget(self, action: #selector(addNoteButtonClicked),
                         for: .touchUpInside)
    }
    
    /// Setup navigation bar for the view.
    func setupNavBar() {
        // Set navigation bar title.
        title = "Notes"
        
        // Set clear navigation bar.
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBarColor(UIColor.systemBackground.withAlphaComponent(0.9))
    }
    
}
