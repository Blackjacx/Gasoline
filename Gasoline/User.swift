//
//  User.swift
//  Gasoline
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit

public struct User: Codable {

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"

        case email
        case firstName = "first_name"
        case lastName = "last_name"
    }

    /// The database id for the model object
    public let id: String
    /// The creation date of the model object
    public let createdAt: Date

    /// The email address of the user
    public let email: String
    /// The first name of the user
    public let firstName: String
    /// The last name of the user
    public let lastName: String
}
