//
//  Note.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-24.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

public class Note {
    
    // MARK: -Class Variables
    
    public var note: String
    
    public var ID: String
    public var lastUpdated: Date
    public var dateCreated: Date
    
    // MARK: -Class Initialization
    
    public init(note: String, id: String, lastUpdated: Date, dateCreated: Date) {
        self.note = note
        self.ID = id
        self.lastUpdated = lastUpdated
        self.dateCreated = dateCreated
    }
    
    public convenience init() {
        self.init(note: "# ", id: "", lastUpdated: Date(), dateCreated: Date())
    }
    
    public convenience init(dictionary: [String: Any]) {
        let note = dictionary["note"] as! String
        let lastUpdatedTimestamp: Timestamp = dictionary["lastUpdated"] as? Timestamp ?? Timestamp()
        let dateCreatedTimestamp: Timestamp = dictionary["dateCreated"] as? Timestamp ?? Timestamp()
        
        let lastUpdated: Date = lastUpdatedTimestamp.dateValue()
        let dateCreated: Date = dateCreatedTimestamp.dateValue()
        
        self.init(note: note, id: "", lastUpdated: lastUpdated, dateCreated: dateCreated)
    }
    
    // MARK: -Firebase Integration
    
    public var dictionaryForAdd: [String: Any] {
        return ["note": note, "lastUpdated": FieldValue.serverTimestamp(), "dateCreated": FieldValue.serverTimestamp()]
    }
    
    public var dictionaryForUpdate: [String: Any] {
        return ["note": note, "lastUpdated": FieldValue.serverTimestamp()]
    }
    
    // MARK: -Functionalitys
    
    /// Add a new note.
    public func addData(completion: @escaping(Bool, Error?) -> ()) {
        let db = Firestore.firestore()
        
        guard let userID = (Auth.auth().currentUser?.uid) else {
            return completion(false, nil)
        }
        
        let dbRef = db.collection(userID).document(userID).collection("notes")
        
        // Save the document to the user's collection and send the possible error through the completion handler.
        dbRef.addDocument(data: self.dictionaryForAdd){ err in
            if let err = err {
                completion(false, err)
                return
            }
            
            completion(true, nil)
            return
        }
        
    }
    
    // Update an existing note.
    public func updateData(completion: @escaping(Bool, Error?) -> ()) {
        let db = Firestore.firestore()
        
        guard let userID = (Auth.auth().currentUser?.uid) else {
            return completion(false, nil)
        }
        
        let dbRef = db.collection(userID).document(userID).collection("notes")
        
        // Save the document to the user's collection and send the possible error through the completion handler.
        dbRef.document(self.ID).updateData(self.dictionaryForUpdate) { err in
            if let err = err {
                completion(false, err)
                return
            }
            
            completion(true, nil)
            return
        }
    }
    
    /// Delete a note.
    public func deleteReminder(completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        
        guard let userID = (Auth.auth().currentUser?.uid) else {
            return completion(false, nil)
        }
        
        let dbRef = db.collection(userID).document(userID).collection("notes")
        
        dbRef.document(self.ID).delete() { error in
            // Remove any pending or outstanding notifications and delete.
            
            if let error = error {
                completion(false, error)
            }
            
            completion(true, nil)
        }
    }
    
}
