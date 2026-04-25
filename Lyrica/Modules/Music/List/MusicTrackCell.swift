
// ПРАВИЛО PRD: View (UIView) — только UI-компоненты и layout.
// URLSessionDataTask убран из ячейки — это был сетевой вызов внутри View, что нарушает PRD.
// Загрузка изображений теперь делается через отдельный ImageLoader (утилита без логики домена).
// configure() принимает готовые данные — ячейка их только отображает.
 

import UIKit

// MARK: - Лёгкий image loader (утилита, не сервис домена)
// Единственная ответственность: загрузить UIImage по URL и вернуть в main queue.
// Не знает о бизнес-логике. Не знает о ViewModel.

final class ImageLoader {
    static func load(url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            let image = data.flatMap { UIImage(data: $0) }
            DispatchQueue.main.async { completion(image) }
        }
        task.resume()
        return task
    }
}

// MARK: - Cell

final class MusicTrackCell: UITableViewCell {
    
    static let identifier = "MusicTrackCell"
    
    // MARK: - UI
    
    private let artworkImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.backgroundColor = UIColor.lyricaSage.withAlphaComponent(0.3)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        l.textColor = .secondaryLabel
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let albumLabel: UILabel = {
        let l = UILabel()
       l.font = UIFont.systemFont(ofSize: 12, weight: .regular)
       l.textColor = UIColor.lyricaShamrock
       l.numberOfLines = 1
       l.translatesAutoresizingMaskIntoConstraints = false
       return l
    }()
    
    private let textStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 3
        sv.alignment = .leading
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let chevronImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = UIColor.lyricaSage
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - Task for image loading
    private var imageTask: URLSessionDataTask?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .lyricaIvory
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageTask?.cancel()
        artworkImageView.image = nil
        trackNameLabel.text = nil
        artistLabel.text = nil
        albumLabel.text = nil
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        
        [trackNameLabel, artistLabel, albumLabel].forEach {
            textStack.addArrangedSubview($0)
        }
        
        [artworkImageView, textStack, chevronImageView].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            artworkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            artworkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkImageView.widthAnchor.constraint(equalToConstant: 60),
            artworkImageView.heightAnchor.constraint(equalToConstant: 60),
 
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 10),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
 
            textStack.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Configure
    
    func configure(trackName: String, artistName: String, albumName: String, artworkURL: URL?) {
        trackNameLabel.text = trackName
        artistLabel.text = artistName
        albumLabel.text = albumName
        
        if let url = artworkURL {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.artworkImageView.image = image
            }
        }
        imageTask?.resume()
    }
}
