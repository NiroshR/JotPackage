//
//  RemindersCollectionViewCell.swift
//  Jot
//
//  Created by Nirosh Ratnarajah on 2020-05-26.
//  Copyright © 2020 Nirosh Ratnarajah. All rights reserved.
//

import UIKit

public protocol RemindersCellDelegate {
    func checkBoxTapped(for cell: RemindersTableCell, isOn: Bool)
}

public class RemindersTableCell: UITableViewCell, BEMCheckBoxDelegate {
    
    // MARK: -Class Variables
    
    public var delegate: RemindersCellDelegate?
    
    public let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        label.baselineAdjustment = .none
        return label
    }()
    
    public let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        label.baselineAdjustment = .none
        return label
    }()
    
    public let checkBox: BEMCheckBox = {
        let check = BEMCheckBox(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        check.onAnimationType = BEMAnimationType.oneStroke
//        check.offAnimationType = BEMAnimationType.fill
        check.translatesAutoresizingMaskIntoConstraints = false
        return check
    }()
    
    // MARK: -Class Initialization
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        self.checkBox.delegate = self
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.checkBox.delegate = self
    }
    
    /// Something Xcode complains about
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -Action Functions
    
    // Add the check box tap delegate function.
    @objc public func didTap(_ checkBox: BEMCheckBox) {
        self.delegate?.checkBoxTapped(for: self, isOn: checkBox.on)
    }
    
    // MARK: -Helper Functions
    
    /// Setup our setting cells.
    func setupViews() {
        // https://stackoverflow.com/questions/53766565/custom-cell-and-stack-view-programmatically
        self.checkBox.delegate = self
        
        addSubview(stackView)
        addSubview(checkBox)
        
        checkBox.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -1).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stackView.rightAnchor.constraint(equalTo: checkBox.leftAnchor, constant: -10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(secondaryLabel)
    }
    
}
