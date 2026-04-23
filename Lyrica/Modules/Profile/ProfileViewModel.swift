
import Foundation

class ProfileViewModel {
    
    // Mark: - Private
    private let authService = AuthService.shared
    
    // Mark: - Output
    var name: String {
        UserDefaults.standard.authorName
    }
    
    var roleTitle: String {
        switch UserDefaults.standard.userRole {
        case .author:
            return "Author"
        case .customer:
            return "Customer"
        case .none:
            return "-"
        }
    }
    
    // Mark: - Actions
    func logout() {
        try? authService.logOut()
    }
}
