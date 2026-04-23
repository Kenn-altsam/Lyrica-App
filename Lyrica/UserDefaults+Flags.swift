

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
    
    var authorName: String {
        get { string(forKey: "authorName") ?? ""}
        set { set(newValue, forKey: "authorName")}
    }
}
