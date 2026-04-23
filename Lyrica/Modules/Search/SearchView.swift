
import UIKit

final class SearchView: UIView {
    
    let searchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search by title, author, genre…"
        sb.searchBarStyle = .minimal
        sb.tintColor = .lyricaShamrock
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    let genreScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let genreStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emptyIconLabel: UILabel = {
        let label = UILabel()
        label.text = "🎵"
        label.font = UIFont.systemFont(ofSize: 52)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emptyTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "No songs found"
        l.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        l.textColor = .label
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let emptySubtitleLabel: UILabel = {
       let label = UILabel()
        label.text = "Try a different keyword or genre"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .lyricaShamrock
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    let tableView: UITableView = {
       let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        tv.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lyricaIvory
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        genreScrollView.addSubview(genreStackView)
        
        [emptyIconLabel, emptyTitleLabel, emptySubtitleLabel].forEach {
            emptyStateView.addSubview($0)
        }
        
        [searchBar, genreScrollView, tableView, emptyStateView, activityIndicator].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // Search bar
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 4),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
 
            // Genre scroll
            genreScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4),
            genreScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            genreScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            genreScrollView.heightAnchor.constraint(equalToConstant: 40),
 
            genreStackView.topAnchor.constraint(equalTo: genreScrollView.topAnchor),
            genreStackView.bottomAnchor.constraint(equalTo: genreScrollView.bottomAnchor),
            genreStackView.leadingAnchor.constraint(equalTo: genreScrollView.leadingAnchor),
            genreStackView.trailingAnchor.constraint(equalTo: genreScrollView.trailingAnchor),
            genreStackView.heightAnchor.constraint(equalTo: genreScrollView.heightAnchor),
 
            // Table
            tableView.topAnchor.constraint(equalTo: genreScrollView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
 
            // Empty state
            emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 40),
 
            emptyIconLabel.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyIconLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
 
            emptyTitleLabel.topAnchor.constraint(equalTo: emptyIconLabel.bottomAnchor, constant: 12),
            emptyTitleLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
 
            emptySubtitleLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: 6),
            emptySubtitleLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptySubtitleLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor),
 
            // Spinner
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 40)
        ])
    }
    
    func buildGenreChips(genres: [String], selectedGenre: String?, target: Any?, action: Selector) {
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for genre in genres {
            let btn = makeChip(title: genre, isSelected: genre == (selectedGenre ?? "All"))
            btn.addTarget(target, action: action, for: .touchUpInside)
        }
    }
    
    func updateChipSelection(selectedGenre: String?) {
        for view in genreStackView.arrangedSubviews {
            guard let btn = view as? UIButton, let title = btn.title(for: .normal) else {
                continue
            }
            
            let isSelected = title == (selectedGenre ?? "All")
            applyChipStyle(btn, isSelected: isSelected)
        }
    }
    
    private func makeChip(title: String, isSelected: Bool) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        btn.layer.cornerRadius = 14
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14)
        btn.configuration = config
        btn.layer.borderWidth = 1.5
        applyChipStyle(btn, isSelected: isSelected)
        return btn
    }
    
    private func applyChipStyle(_ btn: UIButton, isSelected: Bool) {
        if isSelected {
            btn.backgroundColor = .lyricaShamrock
            btn.setTitleColor(.white, for: .normal)
            btn.layer.borderColor = UIColor.lyricaShamrock.cgColor
        } else {
            btn.backgroundColor = .clear
            btn.setTitleColor(.lyricaShamrock, for: .normal)
            btn.layer.borderColor = UIColor.lyricaShamrock.withAlphaComponent(0.4).cgColor
        }
    }
}
