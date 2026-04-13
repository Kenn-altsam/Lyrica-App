//
//  SignUpViewController.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import UIKit
import Combine

class SignUpViewController: UIViewController {
    
    // MARK: - Callbacks (set by Coordinator)
    var onSignUpSuccess: (() -> Void)?
    
    // Mark: - Properties
    private let viewModel: SignUpViewModel
    private let signUpView = SignUpView()
    private var cancellables = Set<AnyCancellable>()
    
    // Mark: - Init
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark: - Lifecycle
    override func loadView() {
        view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        setupBindings()
        signUpView.roleSegmentedControl.addTarget(self, action: #selector(roleDidChange), for: .valueChanged)
    }
    
    // Mark: - Bindings
    private func setupBindings() {
        signUpView.nameTextField.textPublisher
            .compactMap { $0 }
            .assign(to: \.firstName, on: viewModel)
            .store(in: &cancellables)
        
        signUpView.surnameTextField.textPublisher
            .compactMap { $0 }
            .assign(to: \.lastName, on: viewModel)
            .store(in: &cancellables)
        
        signUpView.loginTextField.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        signUpView.passwordField.textPublisher
            .compactMap { $0 }
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        signUpView.repeatPasswordField.textPublisher
            .compactMap { $0 }
            .assign(to: \.repeatPassword, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.$isReadyToSignUp
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isReady in
                self?.signUpView.signUpButton.setEnabled(isReady)
            }
            .store(in: &cancellables)
        
        viewModel.$validationMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.signUpView.validationLabel.text = message
            }
            .store(in: &cancellables)
        
        signUpView.signUpButton.touchUpInsidePublisher
            .sink { [weak self] in
                self?.signUpTapped()
            }
            .store(in: &cancellables)
    }
    
    // Mark: - Actions
    @objc private func roleDidChange() {
        let index = signUpView.roleSegmentedControl.selectedSegmentIndex
        viewModel.role = index == 0 ? .customer : .author
    }
    
    private func signUpTapped() {
        viewModel.signUp()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.showError(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] in
                    self?.onSignUpSuccess?()
                }
            )
            .store(in: &cancellables)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
