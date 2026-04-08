//
//  UserDefaults+Flags.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 06.04.2026.
//

import Foundation

extension UserDefaults {
    
    var hasSeenOnboarding: Bool {
        get { bool(forKey: "hasSeenOnboarding") }
        set { set(newValue, forKey: "hasSeenOnboarding") }
    }
    
    var userRole: UserRole? {
        get {
            guard let raw = string(forKey: "userRole") else { return nil }
            return UserRole(rawValue: raw)
        }
        set { set(newValue?.rawValue, forKey: "userRole") }
    }
    
    var customerName: String {
        get { string(forKey: "customerName") ?? ""}
        set { set(newValue, forKey: "customerName")}
    }
}
