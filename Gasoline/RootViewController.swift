//
//  RootViewController.swift
//  Gasoline
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        let refuelListViewController = RefuelListViewController()
        refuelListViewController.view.layoutIfNeeded() // avoids animated navbar glitch when presented

        refuelListViewController.willMove(toParentViewController: self)
        addChildViewController(refuelListViewController)
        refuelListViewController.didMove(toParentViewController: self)
        refuelListViewController.view.addMaximizedTo(view)
    }
}
