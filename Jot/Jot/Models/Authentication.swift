//
//  Authentication.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-24.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import FirebaseAuth
import JotModelKit

public class Authentication {
    
    /// Login user.
    /// - Parameter email: Email string of user.
    /// - Parameter password: Password string of user.
    public static func login(email: String, password: String, completion: @escaping(Error?) -> ()) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            // We can set our first run state variable to true.
            firstRunSet(doneFirstRun: true)
            completion(nil)
        }
    }
    
    /// Register user.
    /// - Parameter email: Email string of user.
    /// - Parameter password: Password string of user.
    public static func register(email: String, password: String, completion: @escaping(Error?) -> ()) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            // WARNING: We don't check if authResult?.user exists. It is optional.
            // The listener can also listen to this.
            
            // We can set our first run state variable to true.
            firstRunSet(doneFirstRun: true)
            completion(nil)
        }
    }
    
    /// Password reset for  user on login screen.
    /// - Parameter email: Email string of user.
    public static func passwordReset(email: String, completion: @escaping(Error?) -> ()) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
            return
        }
    }
    
    /// Reauthenticate user.
    /// - Note: Needed to update email or password, must before deleting account.
    /// - Parameter email: Email string of user.
    /// - Parameter password: Password string of user.
    public static func reauthenticate(email: String, password: String, completion: @escaping(Error?) -> ()) {
        let user = Auth.auth().currentUser;
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        // If the user reauthenticates properly, then we can delete the account.
        user?.reauthenticate(with: credential, completion: { (result, error) in
            completion(error)
            return
        })
    }
    
    /// Logout authenticated user.
    public static func logout(completion: @escaping(Error?) -> ()) {
        Notes.removeListener()
        Reminders.removeListener()
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            completion(nil)
        } catch let signOutError as NSError {
            completion(signOutError)
        }
        
    }
    
    /// Delete user.
    public static func delete(completion: @escaping (Error?) -> ()) {
        Notes.removeListener()
        Reminders.removeListener()
        
        let user = Auth.auth().currentUser
        
        user?.delete(completion: { (error) in
            completion(error)
        })
        
        firstRunSet(doneFirstRun: false)
        completion(nil)
    }
    
    /// Update user's password.
    /// - Parameter password: Password string of user.
    public static func updatePassword(password: String, completion: @escaping(Error?) -> ()) {
        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
            completion(error)
            return
        }
    }
    
    /// Update user's email.
    /// - Parameter email: Email string of user.
    public static func updateEmail(email: String, completion: @escaping(Error?) -> ()) {
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            completion(error)
            return
        }
    }
    
}
