//
//  SingerHomeViewController.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import UIKit

class CustomerHomeViewController: UIViewController {
    
    // MARK: - Callbacks (set by Coordinator)
    
    var onAddSongTap: (() -> Void)?
    var onSongTap: ((SongModel) -> Void)?
    var onLogout: (() -> Void)?
    
    // MARK: - Properties
    
    private let rootView = CustomerHomeView()
    private let viewModel: CustomerHomeViewModel

    // MARK: - Init
    
    init(viewModel: CustomerHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Songs"
        setupNavBar()
        setupTableView()
        viewModel.onSongsUpdated = { [weak self] in
            self?.rootView.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSongs()
    }
    
    // MARK: - Setup
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addSongTapped)
        )
    }
    
    private func setupTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }
    
    // MARK: - Actions
    @objc
    private func addSongTapped() {
        onAddSongTap?()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension CustomerHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfSongs()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath) as? SongTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.song(at: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSongTap?(viewModel.song(at: indexPath.row))
    }
}

