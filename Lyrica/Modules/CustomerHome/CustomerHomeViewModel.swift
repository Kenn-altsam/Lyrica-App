//
//  AuthorHomeViewModel.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import Foundation
import Combine

class CustomerHomeViewModel {
    
    // Mark: - Output
    var onSongsUpdated: (() -> Void)?
    private(set) var songs: [SongModel] = []
    
    // Mark: - Private
    private let songService = SongService.shared
    private let authService = AuthService()
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
                    self?.onSongsUpdated?()
                }
            )
            .store(in: &cancellables)
    }
    
    func logout() {
        try? authService.logOut()
    }
}
