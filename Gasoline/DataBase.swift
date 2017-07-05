//
//  DataBase.swift
//  Gasoline
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import Foundation

protocol DataBase {

    // Singleton
    static var sharedInstance: DataBase {get}

    func query<T>(completion: ((_ items: [T]) -> Void))
    mutating func add(item: Any, completion: (() -> ()))
}

struct DataBaseImplementation: DataBase {

    // Singleton
    static let sharedInstance: DataBase = DataBaseImplementation()
    private init() {}

    private var store: [Any] = {
        var demoRefuelList: [Refuel] = []
        let refuel = Refuel(
            date: Date(),
            literPrice: 1.359,
            fuelAmount: Measurement(value: 32.36, unit: UnitVolume.liters),
            mileage: Measurement(value: 96000, unit: UnitLength.kilometers))

        demoRefuelList.append(refuel)
        demoRefuelList.append(refuel)
        demoRefuelList.append(refuel)
        demoRefuelList.append(refuel)
        demoRefuelList.append(refuel)
        return demoRefuelList
    }()

    func query<T>(completion: ((_ items: [T]) -> Void)) {

        let queryResult = store.flatMap { $0 as? T }
        completion(queryResult)
    }

    mutating func add(item: Any, completion: (() -> ())) {

        store.append(item)
        completion()
    }
}
