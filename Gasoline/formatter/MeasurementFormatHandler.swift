//
//  MeasurementFormatHandler.swift
//  Gasoline
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

public struct MeasurementFormatHandler {

    public static let shared = MeasurementFormatHandler()
    private init() {}

    private let formatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        return formatter
    }()

    func stringFrom<U>(measurement: Measurement<U>, maximumFractionDigits: Int) -> String {
        return formatter.string(from: measurement)
    }
}
