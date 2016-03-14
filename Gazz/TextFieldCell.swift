//
//  TextFieldCell.swift
//  Gazz
//
//  Created by Stefan Herold on 14/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell, UITextFieldDelegate {

    // MARK: - Private Properties
    private let textField = UITextField()
    
    // MARK: - Property Observer
    var placeholderText: String? {
        didSet {
            textField.placeholder = placeholderText
        }
    }
    
    var textFieldText: String? {
        didSet {
            textField.text = textFieldText
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            textField.backgroundColor = backgroundColor
        }
    }
    
    
    // MARK: - Overrides

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        translatesAutoresizingMaskIntoConstraints = false
        selectionStyle = .None
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = self.backgroundColor
        textField.delegate = self
        
        contentView.addSubviewMaximized(textField)
        
        UIView .pcl_attachDoneButtonToolbarTo(textField, target: textField, action: Selector("resignFirstResponder"))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
