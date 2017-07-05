//
//  Refuel.swift
//  Gasoline
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit

public struct Refuel: Codable {

    enum CodingKeys : String, CodingKey {
        case id
        case createdAt = "created_at"

        case date
        case literPrice = "liter_price"
        case fuelAmount = "fuel_amount"
        case mileage
        case note
    }

    /// The database id for the model object
    public let id: String
    /// The creation date of the model object
    public let createdAt: Date
    

    /// The total costs in the major curency value (Euro, Dollar, ...)
    public var totalCosts: Double { return literPrice * fuelAmount.value }
    /// The date the refuel action has been done
    public let date: Date
    /// The price per liter in the major curency value (Euro, Dollar, ...)
    public let literPrice: Double
    /// The taken fuel amount im milli liters
    public let fuelAmount: Measurement<UnitVolume>
    /// The current mileage directly before the refuel
    public let mileage: Measurement<UnitLength>
    /// An optional note from the user
    public let note: String?
}

extension Refuel {

    init(date: Date, literPrice: Double, fuelAmount: Measurement<UnitVolume>, mileage: Measurement<UnitLength>, note: String? = nil) {

        self.init(
            id: NSUUID().uuidString,
            createdAt: Date(),
            date: date,
            literPrice: literPrice,
            fuelAmount: fuelAmount,
            mileage: mileage,
            note: note)
    }
}
