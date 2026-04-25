//
//  ProfileViewController.swift
//  Lyrica
//

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
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        l.textAlignment = .center
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let roleLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        l.textColor = .white
        l.textAlignment = .justified
        l.layer.cornerRadius = 10
        l.clipsToBounds = true
        l.backgroundColor = .lyricaShamrock
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
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

    // rowStack — свойство класса чтобы к нему обратиться в constraints
    private let rowStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let logoutButton: MainButton = {
        let button = MainButton()
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.systemRed
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        configure()
        setupLayout()
        bindLogout()
    }

    // MARK: - Configure

    private func configure() {
        let name = viewModel.name
        nameLabel.text = name

        let parts = name.split(separator: " ")
        let initials = parts.prefix(2).compactMap { $0.first }.map { String($0) }.joined()
        initialsLabel.text = initials.isEmpty ? "?" : initials

        roleLabel.text = "  \(viewModel.roleTitle)  "
    }

    // MARK: - Bind

    private func bindLogout() {
        logoutButton.touchUpInsidePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.logout()
                self?.onLogout?()
            }
            .store(in: &cancellables)
    }

    // MARK: - Layout

    private func setupLayout() {
        // Инициалы внутри аватара
        avatarCircle.addSubview(initialsLabel)

        // Заполняем rowStack строками
        let rows: [(String, String)] = [
            ("person.fill", viewModel.name),
            ("star.fill",   viewModel.roleTitle)
        ]
        rows.enumerated().forEach { i, row in
            rowStack.addArrangedSubview(makeInfoRow(icon: row.0, text: row.1))
            if i < rows.count - 1 {
                rowStack.addArrangedSubview(makeSeparator())
            }
        }

        // rowStack внутри карточки
        infoCardView.addSubview(rowStack)

        // Центральный стек — аватар + имя + роль + карточка
        let centerStack = UIStackView(arrangedSubviews: [avatarCircle, nameLabel, roleLabel, infoCardView])
        centerStack.axis = .vertical
        centerStack.spacing = 16
        centerStack.alignment = .center
        centerStack.translatesAutoresizingMaskIntoConstraints = false

        [centerStack, logoutButton, appVersionLabel].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            // Аватар
            avatarCircle.widthAnchor.constraint(equalToConstant: 100),
            avatarCircle.heightAnchor.constraint(equalToConstant: 100),

            initialsLabel.centerXAnchor.constraint(equalTo: avatarCircle.centerXAnchor),
            initialsLabel.centerYAnchor.constraint(equalTo: avatarCircle.centerYAnchor),

            // Роль-бейдж высота
            roleLabel.heightAnchor.constraint(equalToConstant: 24),

            // Карточка на всю ширину стека
            infoCardView.leadingAnchor.constraint(equalTo: centerStack.leadingAnchor),
            infoCardView.trailingAnchor.constraint(equalTo: centerStack.trailingAnchor),

            // rowStack внутри карточки
            rowStack.topAnchor.constraint(equalTo: infoCardView.topAnchor),
            rowStack.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor),
            rowStack.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor),
            rowStack.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor),

            // Центральный стек — по центру экрана
            centerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            centerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            centerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

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
        NSLayoutConstraint.activate([sep.heightAnchor.constraint(equalToConstant: 0.5)])
        return sep
    }
}
