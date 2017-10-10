//
//  NumberFormatting.swift
//  Gasoline
//
//  Created by Stefan Herold on 03.10.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import Foundation

public struct NumberFormatting {

    public static let shared = NumberFormatting()
    public var decimalSeparator: String { return formatter.decimalSeparator }

    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    private init() {}

    public func string(from value: NSNumber?) -> String? {

        guard let value = value else { return nil }
        return formatter.string(from: value)
    }

    public func number(from string: String) -> NSNumber? {
        guard let result = formatter.number(from: string) else { return nil }
        return result
    }
}
