//
//  SongTableViewCell.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 11.04.2026.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    static let identifier = "SongTableViewCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
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
    
    func configure(with song: SongModel) {
        titleLabel.text = song.title
        dateLabel.text = song.authorName.isEmpty ? format(date: song.createdAt) : song.authorName
        priceLabel.text = "\(song.price) ₸"
    }
    
    func format(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    func setupLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        layer.cornerRadius = 12
        contentView.backgroundColor = .clear
        
        innerCardView.backgroundColor = .lyricaIvory
        innerCardView.layer.cornerRadius = 12
        innerCardView.layer.borderWidth = 1.5
        innerCardView.layer.borderColor = UIColor.lyricaTerracotta.cgColor
        innerCardView.isUserInteractionEnabled = true
        contentView.addSubview(innerCardView)
        innerCardView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, dateLabel, priceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            innerCardView.addSubview( $0 )
        }
        
        NSLayoutConstraint.activate([
            innerCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            innerCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            innerCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            innerCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            titleLabel.topAnchor.constraint(equalTo: innerCardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: innerCardView.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: innerCardView.bottomAnchor, constant: -12),
            dateLabel.widthAnchor.constraint(equalToConstant: 44),
            
            priceLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: innerCardView.trailingAnchor, constant: -16),
            priceLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
