
import Foundation
import Combine

class CustomerHomeViewModel {
    
    // Mark: - Output
    @Published private(set) var songs: [SongModel] = []
    
    // Mark: - Private
    private let songService = SongService.shared
    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // Mark: - Data
    func numberOfSongs() -> Int {
        songs.count
    }
    
    func song(at index: Int) -> SongModel {
        songs[index]
    }
    
    func fetchSongs() {
        songService.fetchSongs()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error loading songs: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] songs in
                    self?.songs = songs
                }
            )
            .store(in: &cancellables)
    }
    
    func logout() {
        try? authService.logOut()
    }
    
    func subtitle(for song: SongModel) -> String {
        if !song.authorName.isEmpty {
            return song.authorName
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: song.createdAt)
    }
}
