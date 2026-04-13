//
//  SignUpView.swift
//  Turmys App
//
//  Created by Yerkezhan Zheneessova on 10.04.2025.
//

import UIKit

class SignUpView: UIView{
    
    let nameTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "First Name"
        return textField
    }()
    
    let surnameTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Last Name"
        return textField
    }()
    
    let roleSegmentedControl : UISegmentedControl = {
        let roleSegmented = UISegmentedControl(items: ["Author", "Customer"])
        roleSegmented.selectedSegmentIndex = 0
        roleSegmented.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        roleSegmented.selectedSegmentTintColor = .lyricaTerracotta
        roleSegmented.layer.cornerRadius = 10
        roleSegmented.layer.masksToBounds = true
        
        let titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ]
        let selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        roleSegmented.setTitleTextAttributes(titleTextAttributes, for: .normal)
        roleSegmented.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        return roleSegmented
    }()
    
    let loginTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Email"
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let passwordField: MainTextField = {
        let passwordField = MainTextField()
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Password"
        passwordField.textContentType = .oneTimeCode
        return passwordField
    }()

    let repeatPasswordField: MainTextField = {
        let repeatPasswordField = MainTextField()
        repeatPasswordField.isSecureTextEntry = true
        repeatPasswordField.placeholder = "Repeat Password"
        repeatPasswordField.textContentType = .oneTimeCode
        return repeatPasswordField
    }()
    
    let validationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lyricaTerracotta
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let signUpButton : MainButton = {
       let button = MainButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .lyricaTerracotta
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setEnabled(false)
        return button
    }()
    
    let stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lyricaIvory
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        [nameTextField, surnameTextField, roleSegmentedControl, loginTextField, passwordField, repeatPasswordField, validationLabel, signUpButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            surnameTextField.heightAnchor.constraint(equalToConstant: 44),
            roleSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            loginTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            repeatPasswordField.heightAnchor.constraint(equalToConstant: 44),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
