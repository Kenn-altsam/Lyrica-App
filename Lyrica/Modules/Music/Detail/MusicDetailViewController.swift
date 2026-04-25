
// ПРАВИЛО PRD: ViewController заполняет View из ViewModel computed properties.
// "Форматирование данных (дата, цена) — ответственность ViewModel, не ViewController."
// НЕ содержит UI-элементов напрямую.
// НЕ читает поля модели напрямую — только через ViewModel.
// Загрузка изображения — через ImageLoader (утилита), задача отменяется в deinit.

import UIKit
import Combine

final class MusicDetailViewController: UIViewController {

    // MARK: - Properties
    private let viewModel: MusicDetailViewModel
    private let detailView = MusicDetailView()
    private var imageTask: URLSessionDataTask?

    // MARK: - Init

    init(viewModel: MusicDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func loadView() {
        view = detailView  // ← стандартный паттерн из PRD
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .lyricaShamrock

        // ViewController берёт данные из ViewModel — не из модели напрямую
        title = viewModel.trackName
        configure()
    }

    // MARK: - Configure
    // ViewController заполняет View из ViewModel computed properties.

    private func configure() {
        detailView.configure(
            trackName: viewModel.trackName,
            artistName: viewModel.artistName,
            albumName: viewModel.albumName,
            lyrics: viewModel.lyrics
        )

        // Загрузка изображения — ViewController управляет жизненным циклом task'а
        if let url = viewModel.largeArtworkURL {
            imageTask = ImageLoader.load(url: url) { [weak self] image in
                self?.detailView.artworkImageView.image = image
            }
        }
    }

    deinit {
        imageTask?.cancel()
    }
}
