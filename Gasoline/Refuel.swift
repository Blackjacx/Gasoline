//
//  Refuel.swift
//  Gasoline
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit

public struct Refuel: CoreModel {

    struct JsonKey {
        static let totalCosts = "total_costs"
        static let date = "date"
        static let pricePerLiter = "price_per_liter"
        static let fuelAmount = "fuel_amount"
        static let mileage = "mileage"
        static let note = "note"
    }

    /// The model with properties common to all model objects
    public let common: Common

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

        let common = Common(id: NSUUID().uuidString, createdAt: Date())
        self.init(common: common, date: date, literPrice: literPrice, fuelAmount: fuelAmount, mileage: mileage, note: note)
    }
}
