//
//  AppCoordinator.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 04.04.2026.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let authService = AuthService()
    
    private weak var homeNavigationController: UINavigationController?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    private init(windowScene: UIWindowScene) {
        self.window = UIWindow(windowScene: windowScene)
        self.navigationController = UINavigationController()
    }
    
    static func start(windowScene: UIWindowScene) -> AppCoordinator {
        let coordinator = AppCoordinator(windowScene: windowScene)
        coordinator.start()
        return coordinator
    }
    
    // MARK: - Coordinator
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        authService.authStateDidChangePublisher
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self else { return }
                if !UserDefaults.standard.hasSeenOnboarding {
                    self.showOnboarding()
                } else if let user = user {
                    self.fetchProfileAndRoute(user: user)
                } else {
                    self.showLogin()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Auth State
    
    private func fetchProfileAndRoute(user: AuthUser) {
        authService.fetchUserProfile(uid: user.uid)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.routeByRole()
                    }
                }, receiveValue: { [weak self] profile in
                    UserDefaults.standard.userRole = profile.role
                    UserDefaults.standard.customerName = "\(profile.firstName) \(profile.lastName)"
                    self?.routeByRole()
                }
            )
            .store(in: &cancellables)
    }
    
    private func routeByRole() {
        switch UserDefaults.standard.userRole {
        case .singer:
            showSingerHome()
        case .songWriter:
            showSongWriterHome()
        case .none:
            showLogin()
        }
        
    }
    
    // MARK: - Home Screens
    
    private func showSingerHome() {
        
    }
    
    private func showSongWriterHome() {
        
    }

    private func makeTabBar() -> UITabBarController {
        
    }
    
    // MARK: - Task Screens
    
    private func showCreateSong() {
        
    }
    
    private func showSongDetails() {
        
    }
    
    // MARK: - Auth Flow
    
    private func showLogin()  {
        
    }
    
    private func showSignUp() {
        
    }
    
    private func showOnboarding() {
        
    }
    
    // MARK: - Logout
    
    private func handleLogout() {
        
    }
}
