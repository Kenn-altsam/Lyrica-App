
import UIKit

class CreateSongView: UIView {
    
    let songTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Enter Song name"
        textField.autocorrectionType = .no
        return textField
    }()
    
    let priceTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Enter Price"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let genreTextField: MainTextField = {
        let textField = MainTextField()
        textField.placeholder = "Genre (Pop, R&B, Hip-Hop...)"
        textField.autocorrectionType = .no
        return textField
    }()
    
    let lyricsTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Enter lyrics ..."
        textView.autocorrectionType = .no
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
        stackView.backgroundColor = .lyricaShamrock
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
    
    let postSongButton: MainButton = {
        let button = MainButton(type: .system)
        button.setTitle("Post Song", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .lyricaShamrock
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







//
//extension UITextField {
//    func setLeftPaddingPoints(_ amount: CGFloat) {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
//        leftView = paddingView
//        leftViewMode = .always
//    }
//}
