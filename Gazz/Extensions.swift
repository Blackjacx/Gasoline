//
//  Extensions.swift
//  Gazz
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

extension UIView {

    /// Adds the view to a parent view and sets the autolayout constraints so the view is maximized on the
    /// parent respecting the given margin.
    /// - parameter parent: The parent to add the view to.
    /// - parameter margins: The top, left, bottom and right margins from sub view to parent view.
    func addMaximizedTo(_ parent: UIView, margins: UIEdgeInsets = .zero) {
        let constraints: [NSLayoutConstraint] = [
            leftAnchor.constraint(equalTo: parent.leftAnchor, constant: margins.left),
            rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -margins.right),
            topAnchor.constraint(equalTo: parent.topAnchor, constant: margins.top),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -margins.bottom)
        ]

        translatesAutoresizingMaskIntoConstraints = false

        parent.addSubview(self)

        // Activate all NSLayoutConstraints
        NSLayoutConstraint.activate(constraints)
    }

    /// Adds the view to a parent view.
    /// - parameter parent: The parent to add the view to.
    func addTo(_ parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
    }
}

struct GazzColor {

    static let background = UIColor.white
    static let cellSeparator = UIColor.lightGray
}
