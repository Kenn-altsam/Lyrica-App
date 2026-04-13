//
//  ProfileViewModel.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import Foundation

class ProfileViewModel {
    
    // Mark: - Private
    private let authService = AuthService()
    
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
