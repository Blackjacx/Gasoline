//
//  AppDelegate.swift
//  Gasoline
//
//  Created by Stefan Herold on 25/10/15.
//  Copyright © 2015 Stefan Herold. All rights reserved.
//

// IMPROVEMENTS
// TODO: Implement Adding
// TODO: Implement Persistence

// FEATURES
// TODO: Taking Picture of the bill
// TODO: OCR mileage in the car via camera
// TODO: Implement NSNumberFormatter and reduce to 1 textfield for currency: http://stackoverflow.com/questions/276382/what-is-the-best-way-to-enter-numeric-values-with-decimal-points

import UIKit

var globalDataBaseReference: DataBase = DataBaseImplementation.shared

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let rootViewController: RootViewController = RootViewController()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}
