//
//  CoreModel.swift
//  Gazz
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import Foundation

public protocol CoreModel {

    var common: Common {get}

    var id: String {get}
    var createdAt: Date {get}
}

extension CoreModel {

    public var id: String { return common.id }
    public var createdAt: Date { return common.createdAt }
}
