//
//  AppCoordinator.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 04.04.2026.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator {
    
    // Mark: - Properties
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let authService = AuthService()
//    private let authService: AuthService
    
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
    
    // Mark: - Coordinator
    
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
    
    private func showOnboarding() {
        let vc = OnboardingViewController()
        
    }
}
