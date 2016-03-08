//
//  Record.swift
//  Gazz
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit
import Firebase

struct Record {
    
    struct JSON {
        static let creationDate = "creationDate"
        static let totalCosts = "totalCosts"
        static let pricePerLiter = "pricePerLiter"
        static let fuelAmount = "fuelAmount"
        static let mileage = "mileage"
        static let note = "note"
    }
    let key: String
    let ref: Firebase?
    
    let creationDate: NSDate
    let totalCosts: Double
    let pricePerLiter: Double
    let fuelAmount: Double
    let mileage: Int
    let note: String
    
    // Initialize from arbitrary data
    init?(creationDate: NSDate, totalCosts: String, pricePerLiter: String, fuelAmount: String, mileage: String, note: String = "", key: String = "") {
        guard let totalCosts = Double(totalCosts),
            let pricePerLiter = Double(pricePerLiter),
            let fuelAmount = Double(fuelAmount),
            let mileage = Int(mileage) else {
            return nil
        }
        self.key = key
        self.creationDate = creationDate
        self.totalCosts = totalCosts
        self.pricePerLiter = pricePerLiter
        self.fuelAmount = fuelAmount
        self.mileage = mileage
        self.note = note
        self.ref = nil
    }
    
    init?(snapshot: FDataSnapshot) {
        guard let key = snapshot.key,
            let creationDate = snapshot.value[JSON.creationDate] as? String,
            let totalCosts = snapshot.value[JSON.totalCosts] as? Double,
            let pricePerLiter = snapshot.value[JSON.pricePerLiter] as? Double,
            let fuelAmount = snapshot.value[JSON.fuelAmount] as? Double,
            let mileage = snapshot.value[JSON.mileage] as? Int,
            let note = snapshot.value[JSON.note] as? String,
            let ref = snapshot.ref else {
                return nil
        }
        self.key = key
        self.creationDate = FLCDateFormatter.dateFromString(creationDate, usingFormat: FLCDateFormat.RFC3339)!
        self.totalCosts = totalCosts
        self.pricePerLiter = pricePerLiter
        self.fuelAmount = fuelAmount
        self.mileage = mileage
        self.note = note
        self.ref = ref
    }
    
    func toAnyObject() -> AnyObject {
        return [
            JSON.creationDate : FLCDateFormatter.stringFromDate(creationDate, usingFormat: FLCDateFormat.RFC3339)!,
            JSON.totalCosts : totalCosts,
            JSON.pricePerLiter : pricePerLiter,
            JSON.fuelAmount : fuelAmount,
            JSON.mileage : mileage,
            JSON.note : note
        ]
    }
}
