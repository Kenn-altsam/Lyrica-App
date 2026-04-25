
// ПРАВИЛО PRD: ViewController связывает View и ViewModel через Combine.
// Хранит callbacks от Coordinator.
// НЕ содержит UI-элементов напрямую — они все в MusicListView.
// НЕ вызывает navigationController.push — это делает Coordinator через onTrackTap.
// НЕ импортирует другие ViewController.

import UIKit
import Combine

final class MusicListViewController: UIViewController {

    // MARK: - Callback (устанавливается Coordinator)
    var onTrackTap: ((MusicTrack) -> Void)?

    // MARK: - Properties
    private let rootView = MusicListView()          // ← View отдельно
    private let viewModel = MusicListViewModel()        // ← ViewModel отдельно
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    override func loadView() {
        view = rootView  // ← стандартный паттерн из PRD
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Music"
        setupTableView()
        bindViewModel()       // ← Combine-биндинги
        viewModel.fetchTracks()
    }

    // MARK: - Setup

    private func setupTableView() {
        rootView.tableView.dataSource = self
        rootView.tableView.delegate = self
        rootView.tableView.register(MusicTrackCell.self, forCellReuseIdentifier: MusicTrackCell.identifier)
    }

    // MARK: - Combine Bindings
    // ViewController подписывается на @Published свойства ViewModel и обновляет View.

    private func bindViewModel() {
        viewModel.$tracks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tracks in
                guard let self else { return }
                self.rootView.tableView.reloadData()
                self.rootView.showEmpty(tracks.isEmpty && !self.viewModel.isLoading)
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                loading
                    ? self?.rootView.activityIndicator.startAnimating()
                    : self?.rootView.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showError(message)
            }
            .store(in: &cancellables)
    }

    // MARK: - Private helpers

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.fetchTracks()
        })
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate

extension MusicListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfTracks
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MusicTrackCell.identifier,
            for: indexPath
        ) as? MusicTrackCell else { return UITableViewCell() }

        let track = viewModel.track(at: indexPath.row)

        // ViewController передаёт в ячейку готовые данные из ViewModel
        // — ячейка не обращается к ViewModel напрямую
        cell.configure(
            trackName: track.trackName,
            artistName: track.artistName,
            albumName: track.albumName,
            artworkURL: track.artworkURL
        )
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // ViewController не знает, куда идти — он вызывает callback.
        // Coordinator решает, что делать дальше.
        onTrackTap?(viewModel.track(at: indexPath.row))
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        84
    }
}
