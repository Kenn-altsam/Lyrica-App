//
//  SignUpViewModel.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import Foundation
import Combine

class SignUpViewModel {
    
    // Mark: - Input
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    @Published var role: UserRole = .customer
    
    // Mark: - Output
    @Published private(set) var isReadyToSignUp: Bool = false
    @Published private(set) var validationMessage: String = ""
    
    // Mark: - Private
    private let authService = AuthService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        Publishers.CombineLatest4($firstName, $lastName, $email, $password)
            .combineLatest($repeatPassword)
            .map { [weak self] args -> (Bool, String) in
                let (combined, repeatPassword) = args
                let (first, last, email, pwd) = combined
                return self?.validate(first: first, last: last, email: email, pwd: pwd, repeatPwd: repeatPassword) ?? (false, "")
            }
            .sink { [weak self] isReady, message in
                self?.isReadyToSignUp = isReady
                self?.validationMessage = message
            }
            .store(in: &cancellables)
    }
    
    private func validate(first: String, last: String, email: String, pwd: String, repeatPwd: String) -> (Bool, String) {
        if first.isEmpty || last.isEmpty {
            return (false, "Fill in the Name and Surname")
        }
        if !email.contains("@") || !email.contains(".") {
            return (false, "Enter the correct email")
        }
        if pwd.count < 6 {
            return (false, "Password must be at least 6 characters")
        }
        if pwd != repeatPwd {
            return (false, "Password does not match")
        }
        return (true, "")
    }
    
    func signUp() -> AnyPublisher<Void, Error> {
        let profile = UserProfile(
            uid: "",
            firstName: firstName,
            lastName: lastName,
            email: email,
            role: role
        )
        UserDefaults.standard.userRole = role
        UserDefaults.standard.authorName = "\(firstName) \(lastName)"
        return authService.signUp(profile: profile, password: password)
    }
}
