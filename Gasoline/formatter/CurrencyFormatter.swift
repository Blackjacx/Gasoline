//
//  CurrencyFormatter.swift
//  Gasoline
//
//  Created by Stefan Herold on 02.07.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

public struct CurrencyFormatter {

    public static let shared = CurrencyFormatter()

    private init() {}

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    func stringFromValue(value: Double, currencyCode: String, fractionDigits: Int = 2) -> String {
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.currencyCode = currencyCode
        return formatter.string(from: value as NSNumber) ?? "-,--"
    }
}
