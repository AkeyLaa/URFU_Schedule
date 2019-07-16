//
//  UserDefaultsExtension.swift
//  Schedule.Urfu
//
//  Created by Sergey on 02/07/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case isLoggedIn
        case language
        case groupId
        case groupTitle
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaults.UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool{
        return bool(forKey: UserDefaults.UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func setLanguage(value: String) {
        set(value, forKey: UserDefaults.UserDefaultsKeys.language.rawValue)
        synchronize()
    }
    
    func getLanguage() -> String {
        guard let defaultLanguage = string(forKey: UserDefaults.UserDefaultsKeys.language.rawValue) else { return "ru" }
        return defaultLanguage
    }
    
    func setDefaultGroup(title: String, id: String) {
        set(title, forKey: UserDefaults.UserDefaultsKeys.groupTitle.rawValue)
        set(id, forKey: UserDefaults.UserDefaultsKeys.groupId.rawValue)
        synchronize()
    }
    
    func getDefaultGroup() -> [String: String] {
        if let title = string(forKey: UserDefaults.UserDefaultsKeys.groupTitle.rawValue), let id = string(forKey: UserDefaults.UserDefaultsKeys.groupId.rawValue) {
            return [title: id]
        }
        return ["": ""]
    }
}
