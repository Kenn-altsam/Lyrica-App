

import Foundation
import Combine

class CreateSongViewModel {
    
    // Mark: - Private
    private let songService = SongService.shared
    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // Mark: - Actions
    func createSong(title: String, genre: String, lyricsPreview: String, price: Int) -> AnyPublisher<Void, Error> {
        guard let uid = authService.currentUser?.uid else {
            return Fail(error: NSError(domain: "CreateSong", code: -1, userInfo: [NSLocalizedDescriptionKey : "User is not logged in"]))
                .eraseToAnyPublisher()
        }
        let newSong = SongModel(
            title: title,
            genre: genre,
            price: price,
            lyricsPreview: lyricsPreview,
            authorUID: uid,
            authorName: UserDefaults.standard.authorName
        )
        return songService.saveSong(newSong)
    }
    
}
