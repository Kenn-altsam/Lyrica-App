//
//  CreateListingViewController.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import UIKit
import Combine

class CreateSongViewController: UIViewController {
    
    // Mark: Callbacks (set by Coordinator)
    var onSongCreated: (() -> Void)?
    
    // Mark: - Properties
    private let viewModel: CreateSongViewModel
    private let createSongView = CreateSongView()
    private var cancellables = Set<AnyCancellable>()
    
    // Mark: - Init
    
    init(viewModel: CreateSongViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Mark: - Lifecycle
    
    override func loadView() {
        view = createSongView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Song"
        createSongView.postSongButton.addTarget(self, action: #selector(saveSong), for: .touchUpInside)
    }
    
    // Mark: - Actions
    @objc
    private func saveSong() {
        let title = createSongView.songTextField.text ?? ""
        let genre = createSongView.genreTextField.text ?? ""
        let lyricsPreview = createSongView.lyricsTextView.textColor == .lightGray ? "" : createSongView.lyricsTextView.text ?? ""
        let priceText = createSongView.priceTextField.text ?? ""
        let price = Int(priceText) ?? 0
        
        if let titleError = Validator.validate(title: title) {
            showAlert(message: titleError)
            return
        }
        if let lyricsError = Validator.validate(lyrics: lyricsPreview) {
            showAlert(message: lyricsError)
            return
        }
        if let priceError = Validator.validate(priceText: priceText) {
            showAlert(message: priceText)
            return
        }
        
        viewModel.createSong(title: title, genre: genre, lyricsPreview: lyricsPreview, price: price)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.showAlert(message: error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] in
                    self?.onSongCreated?()
                }
            )
            .store(in: &cancellables)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
