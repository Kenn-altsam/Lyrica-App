

import UIKit
import Combine

final class FavoritesViewController: UIViewController {

    // MARK: - Callback
    var onSongTap: ((SongModel) -> Void)?

    // MARK: - Properties
    private let rootView = FavoritesView()
    private let viewModel = FavoritesViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func loadView() { view = rootView }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self

        viewModel.$songs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] songs in
                self?.rootView.showEmpty(songs.isEmpty)
                self?.rootView.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
}

// MARK: - UITableViewDataSource & Delegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfSongs()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SongTableViewCell.identifier, for: indexPath
        ) as? SongTableViewCell else { return UITableViewCell() }

        let song = viewModel.song(at: indexPath.row)
        cell.configure(with: song, subtitle: viewModel.subtitle(for: song))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSongTap?(viewModel.song(at: indexPath.row))
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 72 }

    // Свайп вправо — удалить из избранного
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            self?.viewModel.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        delete.image = UIImage(systemName: "heart.slash.fill")
        delete.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
