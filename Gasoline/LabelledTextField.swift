//
//  LabelledTextField.swift
//  Gasoline
//
//  Created by Stefan Herold on 03.10.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

class LabelledTextField: UIView {

    let titleLabel = UILabel()
    let field = UITextField()

    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var text: String? {
        get { return field.text }
        set { field.text = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTitleLabel()
        setupField()
        setupStack()
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setupTitleLabel() {

        titleLabel.text = "Dummy"
    }

    private func setupField() {

        field.text = "Dummy Text Field"
    }

    private func setupStack() {

        let stack = UIStackView(arrangedSubviews: [titleLabel, field])
        stack.axis = .vertical
        stack.addMaximizedTo(self)
    }
}
