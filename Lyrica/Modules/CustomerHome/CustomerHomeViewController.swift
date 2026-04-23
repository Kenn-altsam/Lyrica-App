

import UIKit
import Combine

class CustomerHomeViewController: UIViewController {
    
    // Mark: - Callbacks (set by Coordinator)
    var onSongTap: ((SongModel) -> Void)?
    var onLogout: (() -> Void)?
    
    // Mark: - Properties
    private let rootView = CustomerHomeView()
    private let viewModel: CustomerHomeViewModel
    
    // Mark: - Cancellables
    
    private var cancellables = Set<AnyCancellable>()
    
    // Mark: - Init
    init(viewModel: CustomerHomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark: - Lifecycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Active Songs"
        setupNavBar()
        setupTableView()
        viewModel.$songs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSongs()
    }
    
    // Mark: - Setup
    private func setupNavBar() {
        
    }
    
    private func setupTableView() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        
    }
}

// Mark: - UITableViewDataSource & UITableViewDelegate

extension CustomerHomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfSongs()
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.identifier, for: indexPath
        ) as? SongTableViewCell else {
            return UITableViewCell()
        }
        let subtitle = viewModel.subtitle(for: viewModel.song(at: indexPath.row))
        cell.configure(with: viewModel.song(at: indexPath.row), subtitle: subtitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSongTap?(viewModel.song(at: indexPath.row))
    }
}
