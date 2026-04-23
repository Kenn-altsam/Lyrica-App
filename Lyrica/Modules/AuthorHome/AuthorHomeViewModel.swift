//
//  SingerHomeViewModel.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import Foundation
import Combine

class AuthorHomeViewModel {
    
    // MARK: - Output
    @Published private(set) var songs: [SongModel] = []
    
    // MARK: - Private
    private let songService = SongService.shared
    private let authService = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Data
    func numberOfSongs() -> Int {
        return songs.count
    }
    
    func song(at index: Int) -> SongModel {
        songs[index]
    }
    
    func fetchSongs() {
        guard let uid = authService.currentUser?.uid else { return }
        
        songService.fetchSongs(for: uid)
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
