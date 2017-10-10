//
//  BaseNavigationViewController.swift
//  Gasoline
//
//  Created by Stefan Herold on 10.10.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

public final class BaseNavigationViewController: UINavigationController {

    // MARK: - Lifecycle

    override public func viewDidLoad() {

        super.viewDidLoad()

        let newTintColor = Colors.secondary
        let newBarTintColor = Colors.navbarBackground
        let newTitleTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: Colors.normalText,
                                                                    .font: UIFont.systemFont(ofSize: 12)]

        let shadowImageHeight = CGSize(width: 1, height: Constants.UI.lineWidth)
        let shadowImage = UIImage(withSolidColor: Colors.shadowColor, size: shadowImageHeight)
        let backgroundImage = UIImage(withSolidColor: newBarTintColor)

        navigationBar.titleTextAttributes = newTitleTextAttributes
        navigationBar.barTintColor = newBarTintColor
        navigationBar.tintColor = newTintColor

        navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationBar.shadowImage = shadowImage

        navigationBar.isTranslucent = false
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return Constants.UI.statusbarStyle
    }
}
