//
//  Reminders.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-24.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import JotModelKit
import FirebaseAuth
import FirebaseFirestore

public class Reminders {
    
    // MARK: -Class Variables
    
    public var remindersArray = [Reminder]()
    
    public var db: Firestore!
    
    static var handle: ListenerRegistration!
    
    // MARK: -Class Initializations
    
    public init() {
        db = Firestore.firestore()
        Reminders.handle = nil
    }
    
    deinit {
        if let handle = Reminders.handle {
            handle.remove()
        }
    }
    
    // MARK: -Functionality
    
    /// Load reminders by adding a listener.
    /// - TODO: May want to load only documents that have changed, not everything. This current method takes a lot of Firestore reads.
    public func loadData(completed: @escaping () -> ()) {
        guard let userID = (Auth.auth().currentUser?.uid) else {
            return completed()
        }
        
        let dbRef = db.collection(userID).document(userID).collection("reminders")
        
        Reminders.handle = dbRef.addSnapshotListener { (querySnapshot, error) in
            if error != nil {
                return completed()
            }
            
            self.remindersArray = []
            
            for document in querySnapshot!.documents {
                let reminder = Reminder(dictionary: document.data())
                reminder.ID = document.documentID
                self.remindersArray.append(reminder)
            }
            
            let removeItem: Bool = hideCompletedRemindersCheck()
            self.remindersArray.removeAll { (reminder) -> Bool in
                return reminder.isCompleted && removeItem
            }
            
            // Sort the array to have due dated items at the top, then alerts,
            // and completed items at the very bottom.
            self.remindersArray.sort { (item1, item2) -> Bool in
                // Send completed items to the bottom of the list.
                if item2.isCompleted != item1.isCompleted {
                    return item1.isCompleted
                }
                
                var alertTime: Bool = false
                // Items with earliest alert time appear at the top.
                let t1a = item1.alertTime ?? Date.distantPast
                let t2a = item2.alertTime ?? Date.distantPast
                alertTime = t1a <= t2a
                
                var dueDate: Bool = false
                // Items with earliest due date appear at the top.
                let t1d = item1.dueDate ?? Date.distantPast
                let t2d = item2.dueDate ?? Date.distantPast
                dueDate = t1d <= t2d
                
                return dueDate && alertTime
            }
            
            self.remindersArray.reverse()
            
            completed()
        }
    }
    
    /// Remove listener for authentication changes.
    static public func removeListener() {
        if (handle != nil) {
            handle.remove()
        }
    }
    
}
