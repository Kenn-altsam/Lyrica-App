
import Foundation
import Combine
import FirebaseAuth
import FirebaseAuthCombineSwift
import FirebaseFirestore

class AuthService {
    
    private let db = Firestore.firestore()
    
    var currentUser: AuthUser? {
        Auth.auth().currentUser
    }
    
    var authStateDidChangePUBLISHER: AnyPublisher<AuthUser?, Never> {
        Auth.auth().authStateDidChangePublisher()
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    // Регистрация: создаём пользователя в Firebase Auth + сохраняем профиль в Firestore
    
    // Mark: - Sign Up
    
    func signUp(profile: UserProfile, password: String) -> AnyPublisher<Void, Error> {
        Auth.auth().createUser(withEmail: profile.email, password: password)
            .flatMap { [weak self] result -> AnyPublisher<Void, Error> in
                guard let self else {
                    return Fail(error: NSError(domain: "AuthService", code: -1))
                        .eraseToAnyPublisher()
                }
                
                let userWithID = UserProfile(
                    uid: result.user.uid,
                    firstName: profile.firstName,
                    lastName: profile.lastName,
                    email: profile.email,
                    role: profile.role
                )
                return self.saveUserProfile(userWithID)
            }
            .eraseToAnyPublisher()
    }
    
    // Mark: - Sign In
    
    func signIn(email: String, password: String) -> AnyPublisher<AuthUser, Error> {
        Auth.auth().signIn(withEmail: email, password: password)
            .map { $0.user as AuthUser }
            .eraseToAnyPublisher()
    }
    
    // Mark: - Log Out
    
    func logOut() throws {
        try Auth.auth().signOut()
    }
    
    func fetchUserProfile(uid: String) -> AnyPublisher<UserProfile, Error> {
        Future { [weak self] promise in
            self?.db.collection("users").document(uid).getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                guard let data = snapshot?.data(),
                        let profile = UserProfile(from: data) else {
                    promise(.failure(NSError(domain: "AuthService", code: -2,
                        userInfo: [NSLocalizedDescriptionKey : "Failed to decode user profile"])))
                    return
                }
                promise(.success(profile))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    private func saveUserProfile(_ profile: UserProfile) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.db.collection("users")
                .document(profile.uid)
                .setData(profile.dictionary) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
