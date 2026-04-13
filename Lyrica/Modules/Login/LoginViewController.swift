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
    private var cancellables = Set<AnyCancellable>()
    
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
        loginView.loginTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        loginView.passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$isReadyToSignIn
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isReady in
                self?.loginView.loginButton.setEnabled(isReady)
            }
            .store(in: &cancellables)
        
        loginView.noAccountButton.touchUpInsidePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.onSignUpTap?()
            }
            .store(in: &cancellables)
        
        loginView.loginButton.touchUpInsidePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.loginTapped()
            }
            .store(in: &cancellables)
        }
    
    // MARK: - Actions
    
    private func loginTapped() {
        loginView.errorLabel.isHidden = true
        
        viewModel.signIn()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.loginView.errorLabel.text = "Incorrect email or password"
                        self?.loginView.errorLabel.isHidden = false
                    }
                },
                receiveValue: { [weak self] user in
                    self?.onLoginSuccess?(user)
                }
            )
            .store(in: &cancellables)
    }
    
}
