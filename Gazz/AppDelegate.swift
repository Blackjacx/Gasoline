//
//  AppDelegate.swift
//  Gazz
//
//  Created by Stefan Herold on 25/10/15.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

// IMPROVEMENTS
// TODO: Save the date with a standardized time 12:00 afternoon
// TODO: Use the decimal keypad and and include a accessory view on top with next prev buttons
// TODO: Make fonts dark gray: 30, 60, ...
// TODO: Realize Datepicker as seperate View and show it from below on button press.
// TODO: Check the Date 22:00 after changing dateii
// TODO: Integrate an advanced date formatter class and a relative date/time format on dashboard
// TODO: Make a replacement for NSUsewrdefaults that stores all frefixes all keys (PLCDataPersistor)

// FEATURES
// TODO: Taking Picture of the bill
// TODO: Use a scroll view to display the content
// TODO: Convert Pictures to b&w images to save space
// TODO: Offer to crop image to save space
// TODO: OCR mileage in the car via camera
// TODO: Implement NSNumberFormatter and reduce to 1 textfield for currency: http://stackoverflow.com/questions/276382/what-is-the-best-way-to-enter-numeric-values-with-decimal-points
// TODO: Toggle Edit/Save depending on mode you are in
// TODO: Make a login screen





import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override init() {
        super.init()
        Firebase.defaultConfig().persistenceEnabled = true
//        Firebase.setLoggingEnabled(true)
    }
}
