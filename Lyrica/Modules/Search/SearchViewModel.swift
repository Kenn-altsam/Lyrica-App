

import Foundation
import Combine

final class SearchViewModel {
    
    // Mark: - Output
    
    @Published private(set) var filteredSongs: [SongModel] = []
    @Published private(set) var isLoading: Bool = false
    
    // Mark: - Input
    
    @Published var searchText: String = ""
        @Published var selectedGenre: String? = nil
    
    // Mark: - Data
    
    let allGenres = ["All", "Pop", "Rock", "Jazz", "Hip-Hop", "Classical", "R&B", "Electronic", "Folk", "Other"]
     
    private var allSongs: [SongModel] = []
    private let songService = SongService.shared
    private var cancellables = Set<AnyCancellable>()
 
    // MARK: - Init
 
    init() {
        // Combine search text + genre → filter
        Publishers.CombineLatest($searchText, $selectedGenre)
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] text, genre in
                self?.applyFilter(text: text, genre: genre)
            }
            .store(in: &cancellables)
    }
 
    // MARK: - Public
 
    func fetchSongs() {
        isLoading = true
        songService.fetchSongs()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] songs in
                    guard let self else { return }
                    self.allSongs = songs
                    self.applyFilter(text: self.searchText, genre: self.selectedGenre)
                }
            )
            .store(in: &cancellables)
    }
 
    func song(at index: Int) -> SongModel {
        filteredSongs[index]
    }
 
    func numberOfSongs() -> Int {
        filteredSongs.count
    }
 
    func subtitle(for song: SongModel) -> String {
        song.authorName.isEmpty ? song.genre : song.authorName
    }
 
    // MARK: - Private
 
    private func applyFilter(text: String, genre: String?) {
        var result = allSongs
 
        // Genre filter
        if let genre, genre != "All" {
            result = result.filter { $0.genre.lowercased() == genre.lowercased() }
        }
 
        // Text filter
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(trimmed) ||
                $0.authorName.localizedCaseInsensitiveContains(trimmed) ||
                $0.genre.localizedCaseInsensitiveContains(trimmed)
            }
        }
 
        filteredSongs = result
    }
}
    
