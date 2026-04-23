

import Foundation
import Combine
import FirebaseFirestore

final class SongService {
    
    static let shared = SongService()
    private init() {}
    
    private let db = Firestore.firestore()
    
    func saveSong(_ song: SongModel) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.db.collection("Songs")
                .document(song.id)
                .setData(song.dictionary) { err in
                    if let err = err {
                        promise(.failure(err))
                    } else {
                        promise(.success(()))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    // Все песни — для автора
    
    func fetchSongs() -> AnyPublisher<[SongModel], Error> {
        Future { [weak self] promise in
            self?.db.collection("Songs")
                .order(by: "createdAt", descending: true)
                .getDocuments { snapshot, err in
                    if let err = err {
                        promise(.failure(err))
                        return
                    }
                    
                    let songs = snapshot?.documents.compactMap {
                        SongModel(from: $0.data())
                    } ?? []
                    promise(.success((songs)))
                }
        }
        .eraseToAnyPublisher()
    }
    
    // Только песни конкретному исполнителю
    
    func fetchSongs(for authorUID: String) -> AnyPublisher<[SongModel], Error> {
        Future { [weak self] promise in
            self?.db.collection("Songs")
                .whereField("authorUID", isEqualTo: authorUID)
                .order(by: "createdAt", descending: true)
                .getDocuments { snapshot, err in
                    if let err = err {
                        promise(.failure(err))
                        return
                    }
                    
                    let songs = snapshot?.documents.compactMap {
                        SongModel(from: $0.data())
                    } ?? []
                    promise(.success((songs)))
                }
        }
        .eraseToAnyPublisher()
    }
}
