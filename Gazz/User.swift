//
//  User.swift
//  Gazz
//
//  Created by Stefan Herold on 08/03/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import UIKit
import Firebase

class User {
    
    struct JSON {
        static let email = "email"
    }
    
    let uid: String
    let email: String
    
    // Initialize from Firebase
    convenience init?(authData: FAuthData) {
        guard let email = authData.providerData[JSON.email] as? String else {
            return nil
        }
        self.init(uid: authData.uid, email: email)
    }
    
    // Initialize from arbitrary data
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
