//
//  ImageCollectionViewCell.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-06-06.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit
import SnapKit

public class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: -Class Variables
    
    public var profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: -Class Initializations
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -Helper Functions
    
    private func setupViews() {
        addSubview(profileImageView)
    }
    
}
