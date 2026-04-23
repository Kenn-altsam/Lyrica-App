

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
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let loginButton: MainButton = {
        let button = MainButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .lyricaShamrock
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.setEnabled(false)
        return button
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lyricaShamrock
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    let noAccountButton: MainButton = {
        let button = MainButton(type: .system)
        button.setTitle("Don't have an account/Sign Up", for: .normal)
        button.setTitleColor(.lyricaShamrock, for: .normal)
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lyricaIvory
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        [loginTextField, passwordTextField, errorLabel, loginButton, noAccountButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            
            loginTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

