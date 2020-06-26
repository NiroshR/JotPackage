//
//  Notes.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-24.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

public class Notes {
    
    // MARK: -Class Variables
    
    public var notesArray = [Note]()
    
    public var db: Firestore!
    
    static var handle: ListenerRegistration!
    
    // MARK: -Class Intialization
    
    public init() {
        db = Firestore.firestore()
        Notes.handle = nil
    }
    
    deinit {
        if let handle = Notes.handle {
            handle.remove()
        }
    }
    
    // MARK: -Functionality
    
    /// Load notes data by addign a listener.
    public func loadData(completed: @escaping () -> ()) {
        guard let userID = (Auth.auth().currentUser?.uid) else {
            return completed()
        }
        
        let dbRef = db.collection(userID).document(userID).collection("notes").order(by: "lastUpdated", descending: true)
        
        Notes.handle = dbRef.addSnapshotListener {[weak self] (querySnapshot, error) in
            // Need weak self to prevent memory leaks.
            guard let self = self else {
                return completed()
            }
            
            if error != nil {
                return completed()
            }
            
            self.notesArray = []
            
            for document in querySnapshot!.documents {
                let reminder = Note(dictionary: document.data())
                reminder.ID = document.documentID
                self.notesArray.append(reminder)
            }
            
            completed()
        }
    }
    
    /// Remove listener for authentication changes.
    public static func removeListener() {
        if (handle != nil) {
            handle.remove()
        }
    }
    
}
