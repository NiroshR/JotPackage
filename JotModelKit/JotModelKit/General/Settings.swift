//
//  Settings.swift
//  JotModelKit
//
//  Created by Nirosh Ratnarajah on 2020-06-23.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit

/// Structure to hold settings menu contents neatly
public struct SettingsModel {
    
    public init(strings: [String], endpoint: UIViewController?) {
        self.strings = strings
        self.endpoint = endpoint
    }
    
    /// Array of strings to hold title and description, or other text.
    /// - Remark: Each index must be manually dereferenced.
    /// - Important: Programmer must ensure we don't access elements outside range.
    public var strings: [String]
    
    /// UIViewController endpoint the settings cell points to.
    /// - Remark: If no view controller is to be set, **nil** is the suggested entry.
    /// - Warning: Make sure to check if endpoint is **nil** before presenting endpoint.
    public var endpoint: UIViewController?
}
