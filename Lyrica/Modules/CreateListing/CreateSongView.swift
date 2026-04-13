//
//  CreateListingView.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import UIKit

class CreateSongView: UIView {
    
    let songTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Song name"
        textField.textColor = .darkGray
        textField.borderStyle = .roundedRect
        textField.setLeftPaddingPoints(12)
        return textField
    }()
    
    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Price"
        textField.textColor = .darkGray
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.setLeftPaddingPoints(12)
        return textField
    }()
    
    let genreTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Genre (Pop, R&B, Hip-Hop...)"
        textField.textColor = .darkGray
        textField.borderStyle = .roundedRect
        textField.setLeftPaddingPoints(12)
        return textField
    }()
    
    let lyricsTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Enter lyrics ..."
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .lyricaTerracotta
        stackView.layer.cornerRadius = 12
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 20, left: 20, bottom: 20, right: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let postSongButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post Song", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .lyricaTerracotta
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .lyricaIvory
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
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
        fatalError( "init(coder:) has not been implemented" )
    }
    
    func setupViews() {
        [songTextField, genreTextField, priceTextField, lyricsTextView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            textFieldStackView.addArrangedSubview($0)
        }
        
        [textFieldStackView, postSongButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            songTextField.heightAnchor.constraint(equalToConstant: 44),
            genreTextField.heightAnchor.constraint(equalToConstant: 44),
            priceTextField.heightAnchor.constraint(equalToConstant: 44),
            lyricsTextView.heightAnchor.constraint(equalToConstant: 150),
            postSongButton.heightAnchor.constraint(equalToConstant: 44),
            postSongButton.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
