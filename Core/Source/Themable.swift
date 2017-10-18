//
//  Colors.swift
//  Core
//
//  Created by Stefan Herold on 03.10.17.
//  Copyright © 2017 Stefan Herold. All rights reserved.
//

import UIKit

public protocol Themable {
    static var colorProvider: ColorProvidable { get }
}

public protocol ColorProvidable {
    static var background: UIColor { get }
}

public struct Colors: ColorProvidable {
    public static let primary: UIColor = UIColor(hex: 0x84d6e9)
    public static let secondary: UIColor = UIColor(hex: 0xb2db5c)
    public static let background: UIColor = UIColor(hex: 0xffffff)
    public static let navbarBackground: UIColor = UIColor(hex: 0xf9f9f9)
    public static let shadowColor: UIColor = UIColor(hex: 0x000000).withAlphaComponent(0.25)
    public static let normalText: UIColor = UIColor(hex: 0x555555)
    public static let lightText: UIColor = UIColor(hex: 0xaaaaaa)

    public static let link: UIColor = secondary
}
