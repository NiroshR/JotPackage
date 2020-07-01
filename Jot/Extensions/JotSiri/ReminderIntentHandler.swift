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
        print(intent.title)
        print(intent.note)
        print(intent.dueDate)
        
        completion(ReminderIntentResponse.success(result: "Successfully"))
    }
    
    func resolveTitle(for intent: ReminderIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if intent.title == "title" {
            completion(INStringResolutionResult.needsValue())
        }else{
            completion(INStringResolutionResult.success(with: intent.title ?? ""))
        }
    }
    
    func resolveNote(for intent: ReminderIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        completion(INStringResolutionResult.success(with: intent.note ?? ""))
    }
    
    func resolveDueDate(for intent: ReminderIntent, with completion: @escaping (INDateComponentsResolutionResult) -> Void) {
        completion(INDateComponentsResolutionResult.success(with: intent.dueDate ?? DateComponents()))
    }
    
    
}
