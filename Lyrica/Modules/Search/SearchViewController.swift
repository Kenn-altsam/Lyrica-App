import UIKit
import Combine

final class SearchViewController: UIViewController {
    
    var onSongTap: ((SongModel) -> Void)?
    
    private let rootView = SearchView()
    private let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        setupSearchBar()
        setupTableView()
        setupGenreChips()
        bindViewModel()
        viewModel.fetchSongs()
    }
    
    private func setupSearchBar() {
        rootView.searchBar.delegate = self
    }
    
    private func setupTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }
 
    private func setupGenreChips() {
        rootView.buildGenreChips(
            genres: viewModel.allGenres,
            selectedGenre: viewModel.selectedGenre,
            target: self,
            action: #selector(genreChipTapped(_:))
        )
    }
    
    private func bindViewModel() {
        viewModel.$filteredSongs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] songs in
                guard let self else { return }
                self.rootView.tableView.reloadData()
                let isEmpty = songs.isEmpty && !self.viewModel.isLoading
                self.rootView.emptyStateView.isHidden = !isEmpty
                self.rootView.tableView.isHidden = isEmpty
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
    }
    
    @objc private func genreChipTapped(_ sender: UIButton) {
            guard let title = sender.title(for: .normal) else { return }
            viewModel.selectedGenre = (title == "All") ? nil : title
            rootView.updateChipSelection(selectedGenre: viewModel.selectedGenre)
            rootView.searchBar.resignFirstResponder()
        }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
 
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchText = ""
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
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
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
}
