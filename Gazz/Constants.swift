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
    private static let kRootURL = "https://gazz.firebaseio.com"
    static let kRecordURL = kRootURL + "/records"
    
    static func recordKey(key: String) -> String {
        return kRecordURL  + "/" + key
    }
    
    // https://gazz.firebaseio.com/<user_id>/
    // https://gazz.firebaseio.com/<user_id>/profile/
    // https://gazz.firebaseio.com/<user_id>/statistics/
    // https://gazz.firebaseio.com/<user_id>/records/
    // https://gazz.firebaseio.com/<user_id>/records/<record_id>/
}