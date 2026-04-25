
// ПРАВИЛО PRD: Coordinator создаёт экраны, устанавливает callbacks на ViewController,
// управляет навигацией. Теперь showMusicDetail создаёт MusicDetailViewModel и
// передаёт его в MusicDetailViewController — как это сделано для SongDetailsViewController.

import UIKit
import Combine

final class AppCoordinator: Coordinator {

    // MARK: - Properties
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
        showSplash()
    }

    private func showSplash() {
        let splash = SplashViewController()
        splash.onFinish = { [weak self] in self?.checkAuthState() }
        navigationController.setViewControllers([splash], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Auth State

    private func checkAuthState() {
        authService.authStateDidChangePublisher
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self else { return }
                self.navigationController.setNavigationBarHidden(false, animated: false)
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

    private func fetchProfileAndRoute(user: AuthUser) {
        authService.fetchUserProfile(uid: user.uid)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion { self?.routeByRole() }
                },
                receiveValue: { [weak self] profile in
                    UserDefaults.standard.userRole = profile.role
                    UserDefaults.standard.authorName = "\(profile.firstName) \(profile.lastName)"
                    self?.routeByRole()
                }
            )
            .store(in: &cancellables)
    }

    private func routeByRole() {
        switch UserDefaults.standard.userRole {
        case .customer: showCustomerHome()
        case .author:   showAuthorHome()
        case .none:     showLogin()
        }
    }

    // MARK: - Home Screens

    private func showAuthorHome() {
        let homeVC = AuthorHomeViewController(viewModel: AuthorHomeViewModel())
        homeVC.onAddSongTap = { [weak self] in self?.showCreateSong() }
        homeVC.onSongTap    = { [weak self] song in self?.showSongDetails(song: song) }
        homeVC.onLogout     = { [weak self] in self?.handleLogout() }
        homeVC.tabBarItem   = UITabBarItem(title: "Songs", image: UIImage(systemName: "list.bullet"), tag: 0)

        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNavigationController = homeNav
        navigationController.setViewControllers([makeTabBar(homeNav: homeNav, showFavorites: false)], animated: true)
    }

    private func showCustomerHome() {
        let homeVC = CustomerHomeViewController(viewModel: CustomerHomeViewModel())
        homeVC.onSongTap = { [weak self] song in self?.showSongDetails(song: song) }
        homeVC.onLogout  = { [weak self] in self?.handleLogout() }
        homeVC.tabBarItem = UITabBarItem(title: "Songs", image: UIImage(systemName: "list.bullet"), tag: 0)

        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNavigationController = homeNav
        navigationController.setViewControllers([makeTabBar(homeNav: homeNav, showFavorites: true)], animated: true)
    }

    // MARK: - Tab Bar

    private func makeTabBar(homeNav: UINavigationController, showFavorites: Bool) -> UITabBarController {

        // --- Search ---
        let searchVC = SearchViewController()
        searchVC.onSongTap = { [weak self] song in
            self?.showSongDetailsFromSearch(song: song, nav: searchVC.navigationController)
        }
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        let searchNav = UINavigationController(rootViewController: searchVC)

        // --- Music (iTunes API) ---
        // Coordinator создаёт MusicViewController и устанавливает callback onTrackTap.
        // MusicViewController не знает о MusicDetailViewController — только Coordinator знает.
        let musicVC = MusicListViewController()
        musicVC.onTrackTap = { [weak self] track in
            self?.showMusicDetail(track: track, nav: musicVC.navigationController)
        }
        musicVC.tabBarItem = UITabBarItem(title: "Music", image: UIImage(systemName: "music.note.list"), tag: 4)
        let musicNav = UINavigationController(rootViewController: musicVC)

        // --- Profile ---
        let profileVC = ProfileViewController(viewModel: ProfileViewModel())
        profileVC.onLogout = { [weak self] in self?.handleLogout() }
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 3)
        let profileNav = UINavigationController(rootViewController: profileVC)

        let tabBar = UITabBarController()
        tabBar.tabBar.tintColor = .lyricaShamrock
        tabBar.tabBar.backgroundColor = .lyricaIvory

        if showFavorites {
            let favVC = FavoritesViewController()
            favVC.onSongTap = { [weak self] song in
                self?.showSongDetailsFromSearch(song: song, nav: favVC.navigationController)
            }
            favVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 2)
            let favNav = UINavigationController(rootViewController: favVC)
            tabBar.viewControllers = [homeNav, searchNav, favNav, musicNav, profileNav]
        } else {
            tabBar.viewControllers = [homeNav, searchNav, musicNav, profileNav]
        }

        return tabBar
    }

    // MARK: - Song Screens

    private func showSongDetails(song: SongModel) {
        let vc = SongDetailsViewController(viewModel: SongDetailsViewModel(song: song))
        homeNavigationController?.pushViewController(vc, animated: true)
    }

    private func showSongDetailsFromSearch(song: SongModel, nav: UINavigationController?) {
        let vc = SongDetailsViewController(viewModel: SongDetailsViewModel(song: song))
        nav?.pushViewController(vc, animated: true)
    }

    // MARK: - Music (iTunes) Detail
    // Coordinator создаёт ViewModel и передаёт его в ViewController — паттерн из PRD.

    private func showMusicDetail(track: MusicTrack, nav: UINavigationController?) {
        let viewModel = MusicDetailViewModel(track: track)          // ← Coordinator создаёт VM
        let vc = MusicDetailViewController(viewModel: viewModel)    // ← передаёт через init
        nav?.pushViewController(vc, animated: true)
    }

    private func showCreateSong() {
        let vc = CreateSongViewController(viewModel: CreateSongViewModel())
        vc.onSongCreated = { [weak self] in
            self?.homeNavigationController?.popViewController(animated: true)
        }
        homeNavigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Auth Flow

    private func showLogin() {
        let vc = LoginViewController(viewModel: LoginViewModel())
        vc.onLoginSuccess = { [weak self] user in self?.fetchProfileAndRoute(user: user) }
        vc.onSignUpTap    = { [weak self] in self?.showSignUp() }
        navigationController.setViewControllers([vc], animated: false)
    }

    private func showSignUp() {
        let vc = SignUpViewController(viewModel: SignUpViewModel())
        vc.onSignUpSuccess = { [weak self] in self?.routeByRole() }
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
