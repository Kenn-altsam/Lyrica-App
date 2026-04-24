

import UIKit
import Combine

class CustomerHomeViewController: UIViewController {
    
    // Mark: - Callbacks (set by Coordinator)
    var onSongTap: ((SongModel) -> Void)?
    var onLogout: (() -> Void)?
    
    // Mark: - Properties
    private let rootView = CustomerHomeView()
    private let viewModel: CustomerHomeViewModel
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
//        setupNavBar()
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
    
//    // Mark: - Setup
//    private func setupNavBar() {
//        
//    }
    
    private func setupTableView() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
    }
    
    // Mark: - Private helpers
    
    private func showFavoriteToast(isFavorited: Bool) {
        let message = isFavorited ? "❤️ Added to Favorites" : "🤍 Removed from Favorites"
            let toast = UILabel()
            toast.text = message
            toast.textAlignment = .center
            toast.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            toast.textColor = .white
            toast.backgroundColor = UIColor.lyricaShamrock.withAlphaComponent(0.92)
            toast.layer.cornerRadius = 16
            toast.clipsToBounds = true
            toast.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(toast)
        
        NSLayoutConstraint.activate([
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.heightAnchor.constraint(equalToConstant: 40),
            toast.widthAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
        
        toast.alpha = 0
        UIView.animate(withDuration: 0.3, animations: { toast.alpha = 1 }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.4, animations: { toast.alpha = 0 }) { _ in
                toast.removeFromSuperview()
            }
        }
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
        let song = viewModel.song(at: indexPath.row)
//        let subtitle = viewModel.subtitle(for: viewModel.song(at: indexPath.row))
        cell.configure(with: song, subtitle: viewModel.subtitle(for: song))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSongTap?(viewModel.song(at: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let song = viewModel.song(at: indexPath.row)
        let isFav = FavoritesService.shared.isFavorite(song)
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            FavoritesService.shared.toggleFavorite(song)
            let nowFav = FavoritesService.shared.isFavorite(song)
            self?.showFavoriteToast(isFavorited: nowFav)
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        action.image = UIImage(systemName: isFav ? "heart.slash.fill" : "heart.fill")
        action.backgroundColor = isFav ? UIColor.systemGray : UIColor.systemPink
        action.title = isFav ? "Remove" : "Favorite"
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
}
