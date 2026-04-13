//
//  ListingDetailsView.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 05.04.2026.
//

import UIKit

class SongDetailsView: UIView {
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Song Title"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lyricsLabel: UILabel = {
        let label = UILabel()
        label.text = "Lyrics"
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lyricaTerracotta.cgColor
        label.layoutMargins = .init(top: 8, left: 8, bottom: 8, right: 8)
        label.layer.cornerRadius = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date: 01.01.2025"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 ₸"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 24
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lyricaIvory
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    func setupViews() {
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addArrangedSubview(priceLabel)
        addSubview(stackView)
        
        [titleLabel, lyricsLabel, horizontalStackView].forEach { stackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 44),
            horizontalStackView.heightAnchor.constraint(equalToConstant: 4),
            lyricsLabel.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            lyricsLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
}
