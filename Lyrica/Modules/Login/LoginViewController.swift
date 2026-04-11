//
//  LoginViewController.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 04.04.2026.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    // MARK: - Callbacks (set by Coordinator)
    var onLoginSuccess: ((AuthUser) -> Void)?
    var onSignUpTap: (() -> Void)?
    
    // MARK: - Properties
    private let viewModel: LoginViewModel
    private let loginView = LoginView()
    private let cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        loginView
    }
    
}
