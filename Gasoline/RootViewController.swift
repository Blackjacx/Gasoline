//
//  RootViewController.swift
//  Gasoline
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit
import Core

class RootViewController: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()

        let refuelListScreen = RefuelListViewController()
        let navigationController = BaseNavigationViewController(rootViewController: refuelListScreen)

        navigationController.willMove(toParentViewController: self)
        addChildViewController(navigationController)
        navigationController.didMove(toParentViewController: self)
        navigationController.view.addMaximizedTo(view)
    }
}
