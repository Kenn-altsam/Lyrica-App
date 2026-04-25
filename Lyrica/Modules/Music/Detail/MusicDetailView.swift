// ПРАВИЛО PRD: View (UIView) — только UI-компоненты и layout. Никакой логики.
// Загрузка изображений убрана отсюда — это сетевой вызов, не ответственность View.
// ViewController вызывает configure(with:) и устанавливает image отдельно.
 

import UIKit

final class MusicDetailView: UIView {

    // MARK: - UI Components

    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let artworkImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = UIColor.lyricaSage.withAlphaComponent(0.3)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // Градиент поверх обложки — только визуальный элемент
    private let gradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [UIColor.clear.cgColor, UIColor.lyricaIvory.cgColor]
        g.locations = [0.5, 1.0]
        return g
    }()

    let trackNameLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        l.textColor = .label
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let artistLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        l.textColor = UIColor.lyricaShamrock
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let albumLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let divider: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lyricaSage.withAlphaComponent(0.4)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let lyricsTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Lyrics"
        l.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        l.textColor = .label
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    let lyricsLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        l.textColor = .darkGray
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lyricaIvory
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Gradient layout update

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = artworkImageView.bounds
    }

    // MARK: - Layout (только layout)

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(artworkImageView)
        artworkImageView.layer.addSublayer(gradientLayer)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistLabel)
        contentView.addSubview(albumLabel)
        contentView.addSubview(divider)
        contentView.addSubview(lyricsTitleLabel)
        contentView.addSubview(lyricsLabel)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            artworkImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artworkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            artworkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor),

            trackNameLabel.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 20),
            trackNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            artistLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 6),
            artistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            artistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            albumLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 2),
            albumLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            albumLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            divider.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 20),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            divider.heightAnchor.constraint(equalToConstant: 1),

            lyricsTitleLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
            lyricsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            lyricsLabel.topAnchor.constraint(equalTo: lyricsTitleLabel.bottomAnchor, constant: 10),
            lyricsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lyricsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lyricsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    // MARK: - Configure (только заполнение UI — без логики)

    func configure(trackName: String, artistName: String, albumName: String, lyrics: String) {
        trackNameLabel.text = trackName
        artistLabel.text = artistName
        albumLabel.text = albumName
        lyricsLabel.text = lyrics
    }
}
