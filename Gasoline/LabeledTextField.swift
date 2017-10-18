//
//  LabeledTextField.swift
//  Gasoline
//
//  Created by Stefan Herold on 03.10.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

class LabeledTextField: UIView {

    let titleLabel = UILabel()
    let textField = UITextField()

    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var text: String? {
        get { return textField.text }
        set { textField.text = newValue }
    }

    var placeholder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTitleLabel()
        setupTextField()
        setupStack()
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setupTitleLabel() {
    }

    private func setupTextField() {
    }

    private func setupStack() {

        let stack = UIStackView(arrangedSubviews: [titleLabel, textField])
        stack.axis = .vertical
        stack.addMaximizedTo(self)
    }
}
