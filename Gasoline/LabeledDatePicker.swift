//
//  LabeledDatePicker.swift
//  Gasoline
//
//  Created by Stefan Herold on 03.10.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

class LabeledDatePicker: UIView {

    private let titleLabel = UILabel()
    private let picker = UIDatePicker()

    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var date: Date {
        get { return picker.date }
        set { picker.date = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTitleLabel()
        setupPicker()
        setupStack()
    }

    @available(*, unavailable, message:"init(coder:) has not been implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setupTitleLabel() {
    }

    private func setupPicker() {

    }

    private func setupStack() {

        let stack = UIStackView(arrangedSubviews: [titleLabel, picker])
        stack.axis = .vertical
        stack.addMaximizedTo(self)
    }
}
