//
//  Dates.swift
//  JotModelKit
//
//  Created by Nirosh Ratnarajah on 2020-06-23.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import Foundation

extension Date {
    
    /// Get the start of the current date to compare.
    /// - Returns: The current date starting at the start of the day's time mark.
    public var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
}


public class DateModel {
    
    // MARK: -Static Formatters
    
    /// Formatter of style: "1 month ago".
    private static let lastUpdatedFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()
    
    /// Formatter of style: "21 July 2019" or "Today".
    private static let relativeDateNoTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// Formatter of style: "21 July 2019".
    private static let longDateNoTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// Formatter of style: "21 Jul 2019 at 9:41 AM".
    private static let mediumDateShortTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    /// Formatter of style: "Wed, Sep 12, 2018".
    private static let customDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("E, MMM d, yyyy")
        return formatter
    }()
    
    // MARK: -Formatting Functions
    
    /// Outputs date in format: "21 July 2019" or "Today".
    public static func formatDueDate(_ date: Date) -> String {
        return DateModel.relativeDateNoTimeFormatter.string(from: date)
    }
    
    /// Outputs date in format: "21 Jul 2019 at 9:41 AM".
    public static func formatAlertTime(_ date: Date) -> String {
        return DateModel.mediumDateShortTimeFormatter.string(from: date)
    }
    
    /// Outputs date in either relative (ex. "Today") format, or shortened format (ex. "Wed, Sep 12, 2018").
    public static func formatDueDateRelativeAndCustom(_ date: Date) -> String {
        // Setup the relative formatter
        let relDF = DateModel.relativeDateNoTimeFormatter.string(from: date)
        // Setup the non-relative formatter
        let absDF = DateModel.longDateNoTimeFormatter.string(from: date)
        
        // If the results are the same then it isn't a relative date.
        // Use your custom formatter. If different, return the relative result.
        if (relDF == absDF) {
            return DateModel.customDateFormatter.string(from: date)
        } else {
            return relDF
        }
    }
    
    /// Outputs relative time from now in format: "1 month ago".
    public static func formatForLastUpdated(_ date: Date) -> String {
        return DateModel.lastUpdatedFormatter.localizedString(for: date, relativeTo: Date().addingTimeInterval(1))
    }
    
}
