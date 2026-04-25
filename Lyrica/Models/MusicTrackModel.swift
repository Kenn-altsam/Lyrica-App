
import Foundation

struct MusicTrack {
    let trackId: Int
    let trackName: String
    let artistName: String
    let albumName: String
    let artworkURL: URL?
    let previewURL: URL?
    let lyrics: String
    
    var largeArtworkURL: URL? {
        guard let url = artworkURL else { return nil }
        let bigger = url.absoluteString.replacingOccurrences(of: "100x100", with: "600x600")
        return URL(string: bigger)
    }
}

struct iTunesSearchResponse: Decodable {
    let results: [iTunesTrack]
}

struct iTunesTrack: Decodable {
    let trackId: Int?
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let artworkUrl100: String?
    let previewUrl: String?
    
    func toMusicTrack() -> MusicTrack? {
        guard
            let id = trackId,
            let name = trackName,
            let artist = artistName
        else { return nil }
        
        return MusicTrack(
            trackId: id,
            trackName: name,
            artistName: artist,
            albumName: collectionName ?? "Unknown Album",
            artworkURL: artworkUrl100.flatMap { URL(string: $0) },
            previewURL: previewUrl.flatMap { URL(string: $0) },
            lyrics: "Lyrics for \"\(name)\" by \(artist) are not available via the iTunes API. \n\nYou can search for the full lyrics on Genius or AZLyrics. \n\nArtist: \(artist)\nAlbum: \(collectionName ?? "-")"
        )
    }
}


