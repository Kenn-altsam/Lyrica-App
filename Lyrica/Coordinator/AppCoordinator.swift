

import UIKit
import Combine

final class AppCoordinator: Coordinator {
    
    // MARK: - Propertiesd
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let authService = AuthService.shared
    
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
                    UserDefaults.standard.authorName = "\(profile.firstName) \(profile.lastName)"
                    self?.routeByRole()
                }
            )
            .store(in: &cancellables)
    }
    
    private func routeByRole() {
        switch UserDefaults.standard.userRole {
        case .customer:
            showCustomerHome()
        case .author:
            showAuthorHome()
        case .none:
            showLogin()
        }
        
    }
    
    // MARK: - Home Screens
    
    private func showAuthorHome() {
        let homeVC = AuthorHomeViewController(viewModel: AuthorHomeViewModel())
        homeVC.onAddSongTap = { [weak self] in
            self?.showCreateSong()
        }
        homeVC.onSongTap = { [weak self] song in
            self?.showSongDetails(song: song)
        }
        homeVC.onLogout = { [weak self] in
            self?.handleLogout()
        }
        homeVC.tabBarItem = UITabBarItem(title: "Songs", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNavigationController = homeNav
        navigationController.setViewControllers( [makeTabBar(homeNav: homeNav)], animated: true)
    }
    
    private func showCustomerHome() {
        let homeVC = CustomerHomeViewController(viewModel: CustomerHomeViewModel())
        homeVC.onSongTap = { [weak self] song in
            self?.showSongDetails(song: song)
        }
        homeVC.onLogout = { [weak self] in
            self?.handleLogout()
        }
        homeVC.tabBarItem = UITabBarItem(title: "Songs", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNavigationController = homeNav
        navigationController.setViewControllers( [makeTabBar(homeNav: homeNav)], animated: true)
    }

    private func makeTabBar(homeNav: UINavigationController) -> UITabBarController {
        let profileVC = ProfileViewController(viewModel: ProfileViewModel())
        profileVC.onLogout = { [weak self] in
            self?.handleLogout()
        }
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        let searchVC = SearchViewController()
        searchVC.onSongTap = { [weak self] song in
            self?.showSongDetailsFromSearch(song: song, searchNav: searchVC.navigationController)
        }
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        let searchNav = UINavigationController(rootViewController: searchVC)
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [homeNav, searchNav, profileNav]
        tabBar.tabBar.tintColor = .lyricaShamrock
        tabBar.tabBar.backgroundColor = .lyricaIvory
        return tabBar
    }
    
    // MARK: - Song Screens
    private func showSongDetailsFromSearch(song: SongModel, searchNav: UINavigationController?) {
        let vc = SongDetailsViewController(viewModel: SongDetailsViewModel(song: song))
        searchNav?.pushViewController(vc, animated: true)
    }
    
    private func showCreateSong() {
        let vc = CreateSongViewController(viewModel: CreateSongViewModel())
        vc.onSongCreated = { [weak self] in
            self?.homeNavigationController?.popViewController(animated: true)
        }
        homeNavigationController?.pushViewController(vc, animated: true)
    }
    
    private func showSongDetails(song: SongModel) {
        let vc = SongDetailsViewController(viewModel: SongDetailsViewModel(song: song))
        homeNavigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Auth Flow
    
    private func showLogin()  {
        let vc = LoginViewController(viewModel: LoginViewModel())
        vc.onLoginSuccess = { [weak self] user in
            self?.fetchProfileAndRoute(user: user)
        }
        vc.onSignUpTap = { [weak self] in
            self?.showSignUp()
        }
        navigationController.setViewControllers( [vc], animated: false)
    }
    
    private func showSignUp() {
        let vc = SignUpViewController(viewModel: SignUpViewModel())
        vc.onSignUpSuccess = { [weak self] in
            self?.routeByRole()
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showOnboarding() {
        let vc = OnboardingViewController()
        vc.onContinue = { [weak self] in
            UserDefaults.standard.hasSeenOnboarding = true
            self?.showLogin()
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: - Logout
    
    private func handleLogout() {
        try? authService.logOut()
        UserDefaults.standard.userRole = nil
        showLogin()
    }
}
