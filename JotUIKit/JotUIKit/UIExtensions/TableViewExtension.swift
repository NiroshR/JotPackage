//
//  TableViewExtension.swift
//  JotUIKit
//
//  Created by Nirosh Ratnarajah on 2020-06-23.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Set a message in a table view instead of blank view.
    /// - Parameter messsage: String of message to be displayed in table view.
    public func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .tertiaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.preferredFont(forTextStyle: .body)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    /// Remove a table view message from table view.
    public func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
