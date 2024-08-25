//
//  KeychainStorage.swift
//  FLixToo
//
//  Created by buixuanhuy on 25/08/2024.
//

import SwiftKeychainWrapper

class KeychainStorage {
    static let shared = KeychainStorage()
    
    private let APIKEY = "APIKEY"
    
    var apiKey: String? {
        get {
            return KeychainWrapper.standard.string(forKey: APIKEY)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: APIKEY)
            } else {
                KeychainWrapper.standard.removeObject(forKey: APIKEY)
            }
        }
    }
}
