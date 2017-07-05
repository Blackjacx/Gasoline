//
//  User.swift
//  Gasoline
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit

public struct User: CoreModel {

    struct JsonKey {
        static let email = "email"
        static let firstName = "first_name"
        static let lastName = "last_name"
    }

    /// The model with properties common to all model objects
    public let common: Common

    /// The email address of the user
    public let email: String
    /// The first name of the user
    public let firstName: String
    /// The last name of the user
    public let lastName: String
}
