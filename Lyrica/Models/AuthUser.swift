
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
