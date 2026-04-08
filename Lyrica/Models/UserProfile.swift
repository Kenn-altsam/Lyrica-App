//
//  UserProfile.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 04.04.2026.
//

import Foundation

struct UserProfile {
    let uid: String
    let firstName: String
    let lastName: String
    let email: String
    let role: UserRole
    
    init(uid: String, firstName: String, lastName: String, email: String, role: UserRole) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.role = role
    }
    
    init?(from dict: [String: Any]) {
        guard
            let uid = dict["uid"] as? String,
            let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String,
            let email = dict["email"] as? String,
            let roleRaw = dict["role"] as? String,
            let role = UserRole(rawValue: roleRaw)
        else { return nil }
        
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.role = role
    }
    
    var dictionary: [String: Any] {
        [
            "uid": uid,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "role": role.rawValue
        ]
    }
}
