//
//  AppDefaults.swift
//  HeadingHome
//
//  Created by Mike Nelson on 7/10/17.
//
//

import Foundation

class AppDefaults {
    
    static let sharedInstance = AppDefaults()
    
    fileprivate var defaults: UserDefaults?
    
    fileprivate init() {
        defaults = UserDefaults.standard
    }
    
    func setString(item: String, key: String) {
        defaults?.set(item, forKey: key)
    }
    
    func getString(key: String) -> String {
        guard let value = defaults?.string(forKey: key) else {
            return ""
        }
        
        return value
    }
}

public enum appKeys: String {
    case contactName = "ContactName"
    case contactNumber = "ContactNumber"
    case home = "HomeLocation"
}
