//
//  Common.swift
//  Gazz
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import Foundation

public struct Common {

    struct JsonKey {
        static let id = "id"
        static let createdAt = "created"
    }

    /// The database id for the model object
    public let id: String
    /// The creation date of the model object
    public let createdAt: Date
}
