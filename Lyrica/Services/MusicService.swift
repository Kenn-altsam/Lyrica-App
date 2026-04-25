import Foundation
import Combine

final class MusicService {
    static let shared = MusicService()
    private init() {}
    
    func fetchTopTracks(term: String = "pop hits 2024") -> AnyPublisher<[MusicTrack], Error> {
        var components = URLComponents(string: "https://itunes.apple.com/search")!
        components.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: "30"),
            URLQueryItem(name: "country", value: "us")
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: iTunesSearchResponse.self, decoder: JSONDecoder())
            .map { $0.results.compactMap { $0.toMusicTrack() } }
            .eraseToAnyPublisher()
    }
}
