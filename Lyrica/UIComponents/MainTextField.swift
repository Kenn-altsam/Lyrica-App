
import UIKit
import Combine

class MainTextField: UITextField {
    
    // MARK: - Combine Publishers
    
    // Publishers for various text field events
    
    private let textSubject = CurrentValueSubject<String?, Never>(nil)
    var textPublisher: AnyPublisher<String?, Never> {
        textSubject.eraseToAnyPublisher()
    }
    
    private let editingChangedSubject = PassthroughSubject<String?, Never>()
    var editingChangedPublisher: AnyPublisher<String?, Never> {
        editingChangedSubject.eraseToAnyPublisher()
    }
    
    private let didBeginEditingSubject = PassthroughSubject<Void, Never>()
    var didBeginEditingPublisher: AnyPublisher<Void, Never> {
        didBeginEditingSubject.eraseToAnyPublisher()
    }
    
    private let didEndEditingSubject = PassthroughSubject<Void, Never>()
    var didEndEditingPublisher: AnyPublisher<Void, Never> {
        didEndEditingSubject.eraseToAnyPublisher()
    }
    
    private let returnKeyPressedSubject = PassthroughSubject<Void, Never>()
    var returnKeyPressedPublisher: AnyPublisher<Void, Never> {
        returnKeyPressedSubject.eraseToAnyPublisher()
    }
    
    override var text: String? {
        didSet {
            textSubject.send(text)
        }
    }
    
    // MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        setupTargets()
    }
    
    private func configureTextField() {
        borderStyle = .roundedRect
    }
    
    private func setupTargets() {
        self.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(handleReturnKeyPress), for: .editingDidEndOnExit)
    }
    
    // Event handlers
    
    @objc
    private func textDidChange() {
        textSubject.send(text)
        editingChangedSubject.send(text)
    }
    
    @objc
    private func textFieldDidBeginEditing() {
        didBeginEditingSubject.send()
    }
    
    @objc private func textFieldDidEndEditing() {
        didEndEditingSubject.send()
    }
    
    @objc private func handleReturnKeyPress() {
        returnKeyPressedSubject.send()
    }
    
    // MARK: - Cleanup
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func setupStyle() {
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        
        font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textColor = .black
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 52))
        leftView = padding
        leftViewMode = .always
    }
    
}
