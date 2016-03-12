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
    let totalCosts: Double
    let pricePerLiter: Double
    let fuelAmount: Double
    let mileage: Int
    let note: String
    
    // Initialize from arbitrary data
    init?(creationDate: NSDate, totalCosts: String, pricePerLiter: String, fuelAmount: String, mileage: String, note: String = "", key: String = "") {
        
        let oTotalCosts = Double(totalCosts)
        let oPricePerLiter = Double(pricePerLiter)
        let oFuelAmount = Double(fuelAmount)
        let oMileage = Int(mileage)
        
        self.key = key
        self.creationDate = creationDate
        self.totalCosts = oTotalCosts ?? 0.0
        self.pricePerLiter = oPricePerLiter ?? 0.0
        self.fuelAmount = oFuelAmount ?? 0.0
        self.mileage = oMileage ?? 0
        self.note = note
        self.ref = nil
        
        if (oTotalCosts == nil) || (oPricePerLiter == nil) || (oFuelAmount == nil) || (oMileage == nil) {
            return nil
        }
    }
    
    init?(snapshot: FDataSnapshot) {
        let key = snapshot.key
        let ref = snapshot.ref
        
        let oCreationDate = snapshot.value[JSON.creationDate] as? String
        let oTotalCosts = snapshot.value[JSON.totalCosts] as? Double
        let oPricePerLiter = snapshot.value[JSON.pricePerLiter] as? Double
        let oFuelAmount = snapshot.value[JSON.fuelAmount] as? Double
        let oMileage = snapshot.value[JSON.mileage] as? Int
        let oNote = snapshot.value[JSON.note] as? String
        
        self.key = key
        self.ref = ref
        self.creationDate = FLCDateFormatter.dateFromString(oCreationDate, usingFormat: FLCDateFormat.RFC3339)!
        self.totalCosts = oTotalCosts ?? 0.0
        self.pricePerLiter = oPricePerLiter ?? 0.0
        self.fuelAmount = oFuelAmount ?? 0.0
        self.mileage = oMileage ?? 0
        self.note = oNote ?? ""
        
        if (oCreationDate == nil) || (oTotalCosts == nil) || (oPricePerLiter == nil) || (oFuelAmount == nil) || (oMileage == nil) || (oNote == nil) {
            return nil
        }
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
