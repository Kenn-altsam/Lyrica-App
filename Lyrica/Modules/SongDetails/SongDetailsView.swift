

import UIKit

class SongDetailsView: UIView {

    // MARK: - UI Elements

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Title"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // ✅ Use UITextView instead of UILabel for proper inset padding
    let lyricsTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Lyrics"
        tv.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tv.textColor = .darkGray
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.layer.borderWidth = 1.5
        tv.layer.borderColor = UIColor.lyricaShamrock.cgColor
        tv.layer.cornerRadius = 10
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Date & Price row

    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Apr 23, 2026"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 $"
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .lyricaShamrock
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let metaStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    let mainStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .fill
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lyricaIvory
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    func setupViews() {
        metaStack.addArrangedSubview(dateLabel)
        metaStack.addArrangedSubview(priceLabel)

        [titleLabel, lyricsTextView, metaStack].forEach { mainStack.addArrangedSubview($0) }

        addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),

            lyricsTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),

            metaStack.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
