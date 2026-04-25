import Foundation
import Combine

final class MusicListViewModel {
    @Published private(set) var tracks: [MusicTrack] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let service = MusicService.shared
    
    func fetchTracks() {
        isLoading = true
        errorMessage = nil
        
        service.fetchTopTracks()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let err) = completion {
                        self?.errorMessage = err.localizedDescription
                    }
                }, receiveValue: { [weak self] tracks in
                    self?.tracks = tracks
                }
            )
            .store(in: &cancellables)
    }
    
    func track(at index: Int) -> MusicTrack {
        tracks[index]
    }
    
    var numberOfTracks: Int {
        tracks.count
    }
}
