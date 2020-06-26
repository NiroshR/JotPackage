//
//  Reminder.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-24.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import JotModelKit

public class Reminder {
    
    // MARK: -Class Variables
    
    public var title: String
    public var note: String
    public var dueDate: Date?
    public var alertTime: Date?
    public var isCompleted: Bool
    public var priority: ReminderPriority?
    public var flagged: Bool?
    
    public var ID: String
    public var lastUpdated: Date
    public var dateCreated: Date
    
    // MARK: -Class Initialization
    
    public init(title: String, note: String, dueDate: Date?, alertTime: Date?, isCompleted: Bool, priority: ReminderPriority, flagged: Bool, id: String, lastUpdated: Date, dateCreated: Date) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.alertTime = alertTime
        self.isCompleted = isCompleted
        self.priority = priority
        self.flagged = flagged
        self.ID = id
        self.lastUpdated = lastUpdated
        self.dateCreated = dateCreated
    }
    
    public convenience init() {
        self.init(title: "", note: "", dueDate: nil, alertTime: nil, isCompleted: false, priority: .None, flagged: false, id: "", lastUpdated: Date(), dateCreated: Date())
    }
    
    public convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String
        let note = dictionary["note"] as! String
        let dueDateTimestamp: Timestamp? = dictionary["dueDate"] as? Timestamp
        let alertTimeTimestamp: Timestamp? = dictionary["alertTime"] as? Timestamp
        let isCompleted = dictionary["isCompleted"] as! Bool
        let priorityString = dictionary["priority"] as? ReminderPriority.RawValue ?? ReminderPriority.None.rawValue
        let priority: ReminderPriority = ReminderPriority(rawValue: priorityString) ?? ReminderPriority.None
        let flagged: Bool? = dictionary["flagged"] as? Bool
        let lastUpdatedTimestamp: Timestamp = dictionary["lastUpdated"] as? Timestamp ?? Timestamp()
        let dateCreatedTimestamp: Timestamp = dictionary["dateCreated"] as? Timestamp ?? Timestamp()
        
        let dueDate: Date? = dueDateTimestamp?.dateValue()
        let alertTime: Date? = alertTimeTimestamp?.dateValue()
        let lastUpdated: Date = lastUpdatedTimestamp.dateValue()
        let dateCreated: Date = dateCreatedTimestamp.dateValue()
        
        self.init(title: title, note: note, dueDate: dueDate, alertTime: alertTime, isCompleted: isCompleted, priority: priority, flagged: flagged ?? false, id: "", lastUpdated: lastUpdated, dateCreated: dateCreated)
    }
    
    // MARK: -Firebase Integrations
    
    public var dictionaryForAdd: [String: Any] {
        var dueDateTimestamp: Timestamp? = nil
        if let time = dueDate {
            dueDateTimestamp = Timestamp(date: time)
        }
        
        var alertTimeTimestamp: Timestamp? = nil
        if let time = alertTime {
            alertTimeTimestamp = Timestamp(date: time)
        }
        
        return ["title": title, "note": note, "dueDate": dueDateTimestamp ?? NSNull(), "alertTime": alertTimeTimestamp ?? NSNull(), "isCompleted": isCompleted, "priority": priority?.rawValue ?? ReminderPriority.None.rawValue, "flagged": flagged ?? false, "lastUpdated": FieldValue.serverTimestamp(), "dateCreated": FieldValue.serverTimestamp()]
    }
    
    public var dictionaryForUpdate: [String: Any] {
        var dueDateTimestamp: Timestamp? = nil
        if let time = dueDate {
            dueDateTimestamp = Timestamp(date: time)
        }
        
        var alertTimeTimestamp: Timestamp? = nil
        if let time = alertTime {
            alertTimeTimestamp = Timestamp(date: time)
        }
        
        return ["title": title, "note": note, "dueDate": dueDateTimestamp ?? NSNull(), "alertTime": alertTimeTimestamp ?? NSNull(), "isCompleted": isCompleted, "priority": priority?.rawValue ?? ReminderPriority.None.rawValue, "flagged": flagged ?? false, "lastUpdated": FieldValue.serverTimestamp()]
    }
    
    // MARK: -Functionality
    
    /// Add a new reminder.
    public func addData(completion: @escaping(Bool, Error?) -> ()) {
        let db = Firestore.firestore()
        
        guard let userID = (Auth.auth().currentUser?.uid) else {
            return completion(false, nil)
        }
        
        let dbRef = db.collection(userID).document(userID).collection("reminders")
        
        // Save the document to the user's collection and send the possible error through the completion handler.
        let messageRef = dbRef.addDocument(data: self.dictionaryForAdd){ err in
            if let err = err {
                completion(false, err)
                return
            }
        }
        
        // Alert Scheduler.
        if let alert = self.alertTime {
            UserAlerts.addAlert(title: title, body: note, date: alert, id: messageRef.documentID) { (error) in
                // Can simply return either nil or an actual error if there is one.
                completion(true, error)
                return
            }
        }
        
        if let date = self.dueDate {
            UserAlerts.addBadge(date: date, id: messageRef.documentID) { (error) in
                // Can simply return either nil or an actual error if there is one.
                completion(true, error)
                return
            }
        }
        
        completion(true, nil)
        return
        
    }
    
    /// Update a reminder.
    public func updateData(completion: @escaping(Bool, Error?) -> ()) {
        let db = Firestore.firestore()
        
        guard let userID = (Auth.auth().currentUser?.uid) else {
            return completion(false, nil)
        }
        
        let dbRef = db.collection(userID).document(userID).collection("reminders")
        
        // Save the document to the user's collection and send the possible error through the completion handler.
        dbRef.document(ID).updateData(dictionaryForUpdate) { err in
            if let err = err {
                completion(false, err)
                return
            }
            
            // If the reminder is completed, remove all notifications.
            if self.isCompleted {
                UserAlerts.deleteAlert(id: self.ID)
            } else {
                // Alert Scheduler.
                if let alert = self.alertTime {
                    UserAlerts.updateAlert(title: self.title, body: self.note, date: alert, id: self.ID) { (error) in
                        // Can simply return either nil or an actual error if there is one.
                        completion(true, error)
                        return
                    }
                    
                }
                
                if let date = self.dueDate {
                    UserAlerts.updateBadge(date: date, id: self.ID) { (error) in
                        // Can simply return either nil or an actual error if there is one.
                        completion(true, error)
                        return
                    }
                }
            }
            
            completion(true, nil)
            return
            
        }
    }
    
    static public func markCompleted(reminderID: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        
        guard let userID = (Auth.auth().currentUser?.uid) else {
            return completion(false, nil)
        }
        
        
        let docRef = db.collection(userID).document(userID).collection("reminders").document(reminderID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data() else {
                    return completion(false, error)
                }
                
                let reminder = Reminder(dictionary: data)
                reminder.ID = reminderID
                reminder.isCompleted = true
                
                // Save the document to the user's collection and send the possible error through the completion handler.
                reminder.updateData{ (success, error) in
                    completion(success, error)
                    return
                }
                
            } else {
                return completion(false, error)
            }
        }
    }
    
    /// Delete a reminder.
    public func deleteReminder(completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        
        guard let userID = (Auth.auth().currentUser?.uid) else {
            return completion(false, nil)
        }
        
        let dbRef = db.collection(userID).document(userID).collection("reminders")
        
        UserAlerts.deleteAlert(id: ID)
        
        dbRef.document(ID).delete() { error in
            
            if let error = error {
                completion(false, error)
            }
            
            completion(true, nil)
        }
    }
    
}
