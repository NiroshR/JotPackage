//
//  SubtitleTableViewCell.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-27.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit

public class SubtitleTableViewCell: UITableViewCell {
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
