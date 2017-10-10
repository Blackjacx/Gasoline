//
//  String+Extensions.swift
//  Core
//
//  Created by Stefan Herold on 10.10.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

public extension String {

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
