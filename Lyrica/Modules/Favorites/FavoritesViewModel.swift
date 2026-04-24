
import Foundation
import Combine

final class FavoritesViewModel {
    
    @Published private(set) var songs: [SongModel] = []
    
    private let service = FavoritesService.shared
    
    // Mark: - Public
    
    func loadFavorites() {
        songs = service.favoriteSongs()
    }
    
    func numberOfSongs() -> Int {
        songs.count
    }
    
    func song(at index: Int) -> SongModel {
        songs[index]
    }
    
    func remove(at index: Int) {
        let song = songs[index]
        service.removeFavorite(song)
        songs.remove(at: index)
    }
    
    func subtitle(for song: SongModel) -> String {
        song.authorName.isEmpty ? song.genre : song.authorName
    }
}
