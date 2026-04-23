

import Foundation

class SongDetailsViewModel {
    
    // Mark: - Properties
    let song: SongModel
    
    // Mark: - Display-ready computed properties
    var title: String {
        song.title
    }
    var lyrics: String {
        song.lyricsPreview
    }
    var authorName: String {
        song.authorName
    }
    
    var formattedPrice: String {
        "\(song.price) $"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: song.createdAt)
    }
    
    // Mark: - Init
    
    init(song: SongModel) {
        self.song = song
    }
}
