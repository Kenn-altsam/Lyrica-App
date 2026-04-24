//
//  SongTableViewCell.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 11.04.2026.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    static let identifier = "SongTableViewCell"
    
    private let genreIconView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 22
        v.backgroundColor =  UIColor.lyricaShamrock.withAlphaComponent(0.15)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let genreIconLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .lyricaShamrock
        label.textAlignment = .right
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let innerCardView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with song: SongModel, subtitle: String) {
        titleLabel.text = song.title
        dateLabel.text = subtitle
        priceLabel.text = "\(song.price) $"
        genreIconLabel.text = genreEmoji(for: song.genre)
    }
    
    private func genreEmoji(for genre: String) -> String {
        switch genre.lowercased() {
            case "pop":        return "🎤"
            case "rock":       return "🎸"
            case "jazz":       return "🎷"
            case "hip-hop":    return "🎧"
            case "classical":  return "🎻"
            case "r&b":        return "🎵"
            case "electronic": return "🎛️"
            case "folk":       return "🪕"
            default:           return "🎶"
        }
    }
    
    func setupLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
 
        innerCardView.backgroundColor = .lyricaIvory
        innerCardView.layer.cornerRadius = 12
        innerCardView.layer.borderWidth = 1.5
        innerCardView.layer.borderColor = UIColor.lyricaShamrock.cgColor
        innerCardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(innerCardView)
 
        genreIconView.addSubview(genreIconLabel)
        [genreIconView, titleLabel, dateLabel, priceLabel].forEach {
            innerCardView.addSubview($0)
        }
 
        NSLayoutConstraint.activate([
            innerCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            innerCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            innerCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            innerCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
 
            // Иконка жанра — слева по центру
            genreIconView.leadingAnchor.constraint(equalTo: innerCardView.leadingAnchor, constant: 12),
            genreIconView.centerYAnchor.constraint(equalTo: innerCardView.centerYAnchor),
            genreIconView.widthAnchor.constraint(equalToConstant: 44),
            genreIconView.heightAnchor.constraint(equalToConstant: 44),
 
            genreIconLabel.centerXAnchor.constraint(equalTo: genreIconView.centerXAnchor),
            genreIconLabel.centerYAnchor.constraint(equalTo: genreIconView.centerYAnchor),
 
            // Цена — справа
            priceLabel.trailingAnchor.constraint(equalTo: innerCardView.trailingAnchor, constant: -14),
            priceLabel.centerYAnchor.constraint(equalTo: innerCardView.centerYAnchor),
            priceLabel.widthAnchor.constraint(equalToConstant: 80),
 
            // Название — между иконкой и ценой
            titleLabel.topAnchor.constraint(equalTo: innerCardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: genreIconView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -8),
 
            // Автор — под названием
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: innerCardView.bottomAnchor, constant: -12)
        ])
    }
}
