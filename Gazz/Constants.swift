//
//  Constants.swift
//  Gazz
//
//  Created by Stefan Herold on 21/02/16.
//  Copyright © 2016 Stefan Herold. All rights reserved.
//

import Foundation

struct Value {
    static let kDefaultRasterSize = 11.0
}

struct UserDefaultsKeys {
    static let RecordList = "kGazzUserDefaultsRecordList"
    static let RecordDictionaryItemId = "RecordDictionaryItemId"
    static let RecordDictionaryItemDate = "RecordDictionaryItemDate"
    static let RecordDictionaryItemTotalCosts = "RecordDictionaryItemTotalCosts"
    static let RecordDictionaryItemPricePerLiter = "RecordDictionaryItemPricePerLiter"
    static let RecordDictionaryItemLiterAmount = "RecordDictionaryItemLiterAmount"
    static let RecordDictionaryItemKilometer = "RecordDictionaryItemKilometer"
}

struct FireBaseURL {
    static let kRootURL = "https://gazz.firebaseio.com"
    static let kRecordURL = kRootURL + "/items"
    
    static func urlForRecordKey(key: String) -> String {
        return kRecordURL  + "/" + key
    }
}