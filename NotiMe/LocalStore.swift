//
//  LocalStore.swift
//  NotiMe
//
//  Created by Olarn U. on 23/6/2564 BE.
//

import Foundation

class LocalStore {
    
    static let keyName = "notiMe.push"
    
    var pushIsEnabled: Bool {
        return UserDefaults.standard.bool(forKey: LocalStore.keyName)
    }
    
    func set(pushEnable: Bool) {
        UserDefaults
            .standard
            .set(pushEnable, forKey: LocalStore.keyName)
    }
}
