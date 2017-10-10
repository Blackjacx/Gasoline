//
//  UIViewController+Extensions.swift
//  Core
//
//  Created by Stefan Herold on 10.10.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

public extension UIViewController {

    @objc func dismissViewControllerAnimated() {

        dismiss(animated: true, completion: nil)
    }

    func applyCloseButtonStyle() {

        guard let presentingViewController = presentingViewController else { return }

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel"),
                                                           style: .plain,
                                                           target: presentingViewController,
                                                           action: #selector(dismissViewControllerAnimated))
    }
}
