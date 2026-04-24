
import Foundation

final class FavoritesService {

    static let shared = FavoritesService()
    private init() {}

    private let key = "lyrica_favorite_song_ids"

    // MARK: - Public

    func isFavorite(_ song: SongModel) -> Bool {
        savedIDs().contains(song.id)
    }

    func addFavorite(_ song: SongModel) {
        var ids = savedIDs()
        guard !ids.contains(song.id) else { return }
        ids.append(song.id)
        save(ids: ids)
        saveSongData(song)
    }

    func removeFavorite(_ song: SongModel) {
        var ids = savedIDs()
        ids.removeAll { $0 == song.id }
        save(ids: ids)
        removeSongData(for: song.id)
    }

    func toggleFavorite(_ song: SongModel) {
        isFavorite(song) ? removeFavorite(song) : addFavorite(song)
    }

    func favoriteSongs() -> [SongModel] {
        savedIDs().compactMap { loadSongData(for: $0) }
    }

    // MARK: - Private

    private func savedIDs() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    private func save(ids: [String]) {
        UserDefaults.standard.set(ids, forKey: key)
    }

    private func saveSongData(_ song: SongModel) {
        if let data = try? JSONEncoder().encode(CodableSong(song)) {
            UserDefaults.standard.set(data, forKey: "lyrica_song_\(song.id)")
        }
    }

    private func removeSongData(for id: String) {
        UserDefaults.standard.removeObject(forKey: "lyrica_song_\(id)")
    }

    private func loadSongData(for id: String) -> SongModel? {
        guard let data = UserDefaults.standard.data(forKey: "lyrica_song_\(id)"),
              let coded = try? JSONDecoder().decode(CodableSong.self, from: data)
        else { return nil }
        return coded.toSongModel()
    }
}

// MARK: - Codable wrapper

private struct CodableSong: Codable {
    let id, title, genre, lyricsPreview, authorUID, authorName: String
    let price: Int
    let createdAt: Date

    init(_ s: SongModel) {
        id = s.id; title = s.title; genre = s.genre
        lyricsPreview = s.lyricsPreview; authorUID = s.authorUID
        authorName = s.authorName; price = s.price; createdAt = s.createdAt
    }

    func toSongModel() -> SongModel {
        SongModel(id: id, title: title, genre: genre, price: price,
                  lyricsPreview: lyricsPreview, createdAt: createdAt,
                  authorUID: authorUID, authorName: authorName)
    }
}
