

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
        createSongView.postSongButton.touchUpInsidePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.saveSong()
            }
            .store(in: &cancellables)
        createSongView.lyricsTextView.delegate = self
    }
    
    // Mark: - Actions
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
            showAlert(message: priceError)
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

extension CreateSongViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter lyrics ..." && textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Enter lyrics ..."
            textView.textColor = .lightGray
        }
    }
}
