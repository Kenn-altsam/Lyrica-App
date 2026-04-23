

import Foundation
import Combine

class LoginViewModel {
    
    // MARK: - Input
    @Published var email: String?
    @Published var password: String?
    
    // MARK: - Output
    @Published private(set) var isReadyToSignIn: Bool = false
    
    // MARK: - Private
    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        $email.combineLatest($password)
            .map { email, password in
                !(email ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !(password ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            .removeDuplicates()
            .assign(to: \.isReadyToSignIn, on: self)
            .store(in: &cancellables)
    }
    
    func signIn() -> AnyPublisher<AuthUser, Error> {
        
        let trimmedEmail = (email ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = (password ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty, !trimmedPassword.isEmpty else {
            let error = NSError(
                domain: "com.lyricaapp.auth",
                code: 401,
                userInfo: [NSLocalizedDescriptionKey : "Invalid email or password. Please try agian."]
            )
            return Fail(error: error).eraseToAnyPublisher()
        }
        return authService.signIn(email: trimmedEmail, password: trimmedPassword)
    }
}
