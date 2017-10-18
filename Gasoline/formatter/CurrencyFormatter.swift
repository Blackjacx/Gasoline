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
    public var currencyCode: String { return formatter.currencyCode }
    private var defaultString: String { return "-\(formatter.decimalSeparator)--" }

    private init() {}

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    func stringFromValue(value: Decimal?, currencyCode: String, fractionDigits: Int = 2) -> String {

        guard let value = value else { return defaultString }
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.currencyCode = currencyCode
        return formatter.string(from: value as NSDecimalNumber) ?? defaultString
    }
}
