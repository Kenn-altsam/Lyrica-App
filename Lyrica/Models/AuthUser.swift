//
//  AuthUser.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseAuthInterop

protocol AuthUser: AnyObject {
    var uid: String { get }
    var email: String? { get }
    var displayName: String? { get }
    var phoneNumber: String? { get }
    var isAnonymous: Bool { get }
    var isEmailVerified: Bool { get }
    var providerData: [UserInfo] { get }
}

extension User: AuthUser {}
