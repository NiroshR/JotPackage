//
//  EditNoteViews.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-29.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit

extension EditNoteVC {
    
    /// Setup the note view and setup the Marklight markdown syntax.
    func setupView() {
        // Set background colour.
        view.backgroundColor = .systemBackground
        
        markdownTextView = MarklightTextView(self, text: note.note)
        
        let textView = markdownTextView.textView
        
        view.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-15).priority(.required)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15).priority(.required)
            make.topMargin.equalTo(view.safeAreaLayoutGuide.snp.topMargin).priority(.required)
            make.bottomMargin.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
    }
    
    /// Setup navigation bar for the view.
    func setupNavBar() {
        // Set clear navigation bar.
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.setBarColor(UIColor.clear)
        
        // Add info button for info.
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = barButton
        
    }
    
}
