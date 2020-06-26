//
//  Reminders.swift
//  JotWidget
//
//  Created by Nirosh Ratnarajah on 2020-06-25.
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
    public func loadData(completed: @escaping (Bool, Error?) -> ()) {
        
        var userID = ""
        
        if let id = UserDefaults(suiteName: "group.dev.ratnarajah.Jot")?.string(forKey: "key1") {
            userID = id
        } else {
            completed(false, nil)
            return
        }
        
        if userID.isEmpty {
            return completed(false, nil)
        }
        
        let dbRef = db.collection(userID).document(userID).collection("reminders").whereField("isCompleted", isEqualTo: false)
        
        Reminders.handle = dbRef.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                return completed(false, error)
            }
            
            guard let snapshot = querySnapshot else {
                print("Error retreiving snapshot: \(error!)")
                return completed(false, error)
            }
            
            self.remindersArray = []
            
            for document in snapshot.documents {
                let reminder = Reminder(dictionary: document.data())
                reminder.ID = document.documentID
                self.remindersArray.append(reminder)
            }
            
            let source = snapshot.metadata.isFromCache ? "local cache" : "server"
            print("Metadata: Data fetched from \(source)")
            
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
            
            return completed(true, nil)
        }
    }
    
    /// Remove listener for authentication changes.
    static public func removeListener() {
        if (handle != nil) {
            handle.remove()
        }
    }
    
}
