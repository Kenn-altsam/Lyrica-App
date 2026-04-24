

import UIKit
import Combine

class ProfileViewController: UIViewController {

    var onLogout: (() -> Void)?

    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI

    private let avatarCircle: UIView = {
        let v = UIView()
        v.backgroundColor = .lyricaShamrock
        v.layer.cornerRadius = 50
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let initialsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.backgroundColor = .lyricaShamrock
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let infoCardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowRadius = 8
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let appVersionLabel: UILabel = {
        let l = UILabel()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        l.text = "Lyrica v\(version)"
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .tertiaryLabel
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let logoutButton: MainButton = {
        let button = MainButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

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

    // MARK: - Configure

    private func configure() {
        let name = viewModel.name
        nameLabel.text = name

        // Инициалы: "Altynbek Kenzhe" → "AK"
        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }.map { String($0) }.joined()
        initialsLabel.text = initials.isEmpty ? "?" : initials

        roleLabel.text = "  \(viewModel.roleTitle)  "
    }

    // MARK: - Layout

    private func setupLayout() {
        avatarCircle.addSubview(initialsLabel)

        // Строки инфо-карточки
        let rows: [(String, String)] = [
            ("person.fill", viewModel.name),
            ("star.fill",   viewModel.roleTitle)
        ]

        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 0
        rowStack.translatesAutoresizingMaskIntoConstraints = false

        rows.enumerated().forEach { i, row in
            let rowView = makeInfoRow(icon: row.0, text: row.1)
            rowStack.addArrangedSubview(rowView)
            if i < rows.count - 1 {
                let sep = makeSeparator()
                rowStack.addArrangedSubview(sep)
            }
        }

        infoCardView.addSubview(rowStack)

        [avatarCircle, nameLabel, roleLabel, infoCardView, logoutButton, appVersionLabel].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            // Аватар
            avatarCircle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarCircle.widthAnchor.constraint(equalToConstant: 100),
            avatarCircle.heightAnchor.constraint(equalToConstant: 100),

            initialsLabel.centerXAnchor.constraint(equalTo: avatarCircle.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: avatarCircle.centerYAnchor),

            // Имя
            nameLabel.topAnchor.constraint(equalTo: avatarCircle.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            // Роль-бейдж
            roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            roleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roleLabel.heightAnchor.constraint(equalToConstant: 24),

            // Карточка
            infoCardView.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 28),
            infoCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            rowStack.topAnchor.constraint(equalTo: infoCardView.topAnchor),
            rowStack.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor),
            rowStack.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor),
            rowStack.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor),

            // Кнопка выхода
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 52),
            logoutButton.bottomAnchor.constraint(equalTo: appVersionLabel.topAnchor, constant: -12),

            // Версия
            appVersionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            appVersionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Helpers

    private func makeInfoRow(icon: String, text: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .lyricaShamrock
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(iconView)
        container.addSubview(label)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 52),
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])

        return container
    }

    private func makeSeparator() -> UIView {
        let sep = UIView()
        sep.backgroundColor = UIColor.separator
        sep.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sep.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        return sep
    }

    // MARK: - Actions

    private func logoutTapped() {
        viewModel.logout()
        onLogout?()
    }
}
