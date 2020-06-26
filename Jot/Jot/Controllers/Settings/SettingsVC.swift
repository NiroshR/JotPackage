//
//  SettingsVC.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-20.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import FirebaseAuth
import JGProgressHUD
import os
import UIKit
import JotModelKit

class SettingsVC: UITableViewController {
    
    // MARK: -Class Variables
    
    let app = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "\(URL(fileURLWithPath: #file).deletingPathExtension().lastPathComponent)")
    
    let sections = ["General", "Reminders", "Account", ""]
    
    var generalList: [SettingsModel] = [SettingsModel(strings: ["Background Image", "crop"], endpoint: BackgroundImageVC())]
    
    var accountList: [SettingsModel] = [SettingsModel(strings: ["Update Email", "envelope"], endpoint: UpdateEmailVC()),
                                       SettingsModel(strings: ["Update Password", "lock"], endpoint: UpdatePasswordVC())]
    
    var remindersList: [SettingsModel] = [SettingsModel(strings: ["Hide Completed", "checkmark.circle"], endpoint: nil)]
    
    var accountOutList: [SettingsModel] = [SettingsModel(strings: ["Sign Out", "person", ""], endpoint: nil),
                                          SettingsModel(strings: ["Delete Account", "trash", ""], endpoint: nil)]
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    // MARK: -Class Override Functions
    
    override func viewDidLoad() {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        super.viewDidLoad()
        
        // Set navigation bar.
        self.title = "Settings"
        self.view.backgroundColor = .secondarySystemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Log the operating function.
        os_log(.info, log: self.app, "%@", #function)
        
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
        
        // If a user is logged out or deleted, the view will be dismissed.
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.hud.dismiss(animated: true)
                
                // Need a reference to the current presenting view controller and then present the LoginVC.
                weak var pvc = self.presentingViewController
                
                // Dismiss the settings VC, and show the register screen.
                self.dismiss(animated: true, completion: {
                    let authenticationController = AuthenticationVC()
                    let authenticationNavigationController = UINavigationController(rootViewController: authenticationController)
                    authenticationNavigationController.modalPresentationStyle = .fullScreen
                    pvc?.present(authenticationNavigationController, animated: true, completion: nil)
                })
            }
        }
    }
    
    // MARK: -Tableview Sections
    
    /// Number of rows per section.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return generalList.count
        case 1:
            return remindersList.count
        case 2:
            return accountList.count
        case 3:
            return accountOutList.count
        default:
            return 0
        }
    }
    
    /// Number of section to make.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    /// Title for sections.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    /// Set the section title font and background to match the rest of the view.
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        headerView.textLabel!.font = UIFont.preferredFont(forTextStyle: .callout)
        headerView.tintColor = .secondarySystemBackground
        headerView.textLabel!.textColor = UIColor.label
        headerView.textLabel?.numberOfLines = 0
    }
    
    // MARK: -Tableview Rows
    
    /// Set the text for rows.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCellID", for: indexPath)
        
        switch (indexPath.section) {
        case 0:
            // For more cell details: https://developer.apple.com/documentation/uikit/uitableviewcell
            cell.textLabel?.text = generalList[indexPath.row].strings[0]
            cell.accessoryType = .disclosureIndicator
            
            cell.imageView?.image = UIImage(systemName: generalList[indexPath.row].strings[1])
        case 1:
            cell.textLabel?.text = remindersList[indexPath.row].strings[0]
            cell.imageView?.image = UIImage(systemName: remindersList[indexPath.row].strings[1])
            
            // Add switch to the cell to toggle the completed setting.
            let switchView = UISwitch(frame: .zero)
            switchView.setOn(hideCompletedRemindersCheck(), animated: true)
            switchView.tag = indexPath.row // for detect which row switch Changed
            switchView.addTarget(self, action: #selector(self.showCompletedRemindersSwitch(_:)), for: .valueChanged)
            cell.accessoryView = switchView
        case 2:
            // For more cell details: https://developer.apple.com/documentation/uikit/uitableviewcell
            cell.textLabel?.text = accountList[indexPath.row].strings[0]
            cell.accessoryType = .disclosureIndicator
            
            cell.imageView?.image = UIImage(systemName: accountList[indexPath.row].strings[1])
        case 3:
            // For more cell details: https://developer.apple.com/documentation/uikit/uitableviewcell
            cell.textLabel?.text = accountOutList[indexPath.row].strings[0]
            cell.textLabel?.textColor = UIColor.systemRed
        default:
            return cell
        }
        return cell
    }
    
    /// Size of row depending on section.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
            // Grab the endpoint to go to.
            guard let newVc = generalList[indexPath.row].endpoint else {
                os_log(.info, log: self.app, "No endpoint from general list, index: %d", indexPath.row)
                return
            }
            let navigationVC = self.navigationController
            navigationVC!.pushViewController(newVc, animated: true)
        case 1:
            return
        case 2:
            // Grab the endpoint to go to.
            guard let newVc = accountList[indexPath.row].endpoint else {
                os_log(.info, log: self.app, "No endpoint from account list, index: %d", indexPath.row)
                return
            }
            let navigationVC = self.navigationController
            navigationVC!.pushViewController(newVc, animated: true)
        case 3:
            // If we select the Logout row we execute a different set of logic.
            if accountOutList[indexPath.row].strings[0] == "Sign Out" {
                signOut()
                return
            }
            
            // If we select the Logout row we execute a different set of logic.
            if accountOutList[indexPath.row].strings[0] == "Delete Account" {
                deleteAccount()
                return
            }
        default:
            fatalError("Cell being created in section that doesn't exist")
        }
        
    }
    
    // MARK: Action Functions
    
    /// Close the Settings VC.
    @objc func closeView() {
        self.dismiss(animated: true)
    }
    
    /// Load the reminders switch.
    @objc func showCompletedRemindersSwitch(_ sender : UISwitch!){
        hideCompletedRemindersSet(isHidden: sender.isOn)
    }
    
}
