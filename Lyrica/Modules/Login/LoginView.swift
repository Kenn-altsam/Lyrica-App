//
//  LoginView.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 04.04.2026.
//

import UIKit

class LoginView: UIView {
    
    let loginTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Login"
        return textField
    }()
    
    let passwordTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Password"
        textField.isHidden = true
        return textField
    }()
    
    let loginButton: MainButton = {
        let button = MainButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .lyricaTerracotta
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setEnabled(false)
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lyricaTerracotta
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    let noAccountButton: MainButton = {
        
    }
}

