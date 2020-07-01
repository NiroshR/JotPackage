//
//  ReminderIntentHandler.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-07-01.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import Foundation
import Intents

class ReminderIntentHandler: NSObject, ReminderIntentHandling {
    func handle(intent: ReminderIntent, completion: @escaping (ReminderIntentResponse) -> Void) {
        <#code#>
    }
    
    func resolveTitle(for intent: ReminderIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        <#code#>
    }
    
    func resolveNote(for intent: ReminderIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        <#code#>
    }
    
    func resolveDueDate(for intent: ReminderIntent, with completion: @escaping (INDateComponentsResolutionResult) -> Void) {
        <#code#>
    }
    
    
}
