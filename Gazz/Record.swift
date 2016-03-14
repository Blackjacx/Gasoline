//
//  Record.swift
//  Gazz
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit
import Firebase

class Record {
    
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
    let totalCosts: NSDecimalNumber
    let pricePerLiter: NSDecimalNumber
    let fuelAmount: NSDecimalNumber
    let mileage: Int
    let note: String
    
    // Initialize from arbitrary data
    init(creationDate: NSDate, totalCosts: NSDecimalNumber, pricePerLiter: NSDecimalNumber, fuelAmount: NSDecimalNumber, mileage: Int, note: String, key: String = "", ref: Firebase? = nil) {
        
        self.key = key
        self.creationDate = creationDate
        self.totalCosts = totalCosts
        self.pricePerLiter = pricePerLiter
        self.fuelAmount = fuelAmount
        self.mileage = mileage
        self.note = note
        self.ref = ref
    }
    
    convenience init?(snapshot: FDataSnapshot) {
        guard let oCreationDate = snapshot.value[JSON.creationDate] as? String,
            let date = FLCDateFormatter.dateFromString(oCreationDate, usingFormat: FLCDateFormat.RFC3339),
            let totalCosts = snapshot.value[JSON.totalCosts] as? Double,
            let pricePerLiter = snapshot.value[JSON.pricePerLiter] as? Double,
            let fuelAmount = snapshot.value[JSON.fuelAmount] as? Double,
            let mileage = snapshot.value[JSON.mileage] as? Int,
            let note = snapshot.value[JSON.note] as? String else {
                return nil
        }
        self.init(creationDate: date, totalCosts: NSDecimalNumber(double: totalCosts), pricePerLiter: NSDecimalNumber(double: pricePerLiter), fuelAmount: NSDecimalNumber(double: fuelAmount), mileage: mileage, note: note, key: snapshot.key, ref: snapshot.ref)
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
