
import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    // Mark: Callbacks (set by Coordinator)
    var onLogout: (() -> Void)?
    
    // Mark: - Properties
    private let viewModel: ProfileViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    // Mark: - UI
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 60)
        label.text = "👤"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lyricaShamrock
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let logoutButton: MainButton = {
        let button = MainButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .lyricaShamrock
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Mark: - Init
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lyricaIvory
        title = "Profile"
        setupLayout()
        configure()
        logoutButton.touchUpInsidePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.logoutTapped()
            }
            .store(in: &cancellables)
    }
    
    // Mark: - Setup
    private func configure() {
        nameLabel.text = viewModel.name
        roleLabel.text = viewModel.roleTitle
    }
    
    private func setupLayout() {
        [avatarLabel, nameLabel, roleLabel].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(stackView)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
        
    }
    
    // Mark - Actions
    private func logoutTapped() {
        viewModel.logout()
        onLogout?()
    }
}
