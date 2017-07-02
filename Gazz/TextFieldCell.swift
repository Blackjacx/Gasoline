//
//  TextFieldCell.swift
//  Gazz
//
//  Created by Stefan Herold on 14/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    // MARK: - Private Properties
    lazy private(set) var textField: UITextField = { [weak self] in
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = self?.backgroundColor
        return textField
    }()
    
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

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textField.addMaximizedTo(contentView)
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension TextFieldCell: UITextFieldDelegate {

}
