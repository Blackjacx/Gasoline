//
//  MeasurementFormatting.swift
//  Gasoline
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

public struct MeasurementFormatting {

    public static let shared = MeasurementFormatting()

    private var formatter: MeasurementFormatter = MeasurementFormatter()
    private var numberFormatter: NumberFormatter = NumberFormatter()

    private init() {}

    func stringFrom<U>(measurement: Measurement<U>, fractionDigits: Int) -> String {
        numberFormatter.minimumFractionDigits = fractionDigits
        numberFormatter.maximumFractionDigits = fractionDigits
        formatter.numberFormatter = numberFormatter
        return formatter.string(from: measurement)
    }
}
