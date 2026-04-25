
import Foundation
import Combine

final class MusicDetailViewModel {
    
    // MARK: - Private
    private let track: MusicTrack
    
    // MARK: - Init
    init(track: MusicTrack) {
        self.track = track
    }
    
    // MARK: - Computed Properties
    var trackName: String {
        track.trackName
    }
    var artistName: String {
        track.artistName
    }
    var albumName: String {
        track.albumName
    }
    var lyrics: String {
        track.lyrics
    }
    
    var largeArtworkURL: URL? {
        track.largeArtworkURL
    }
}
