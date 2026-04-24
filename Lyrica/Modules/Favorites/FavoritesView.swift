
import UIKit

final class FavoritesView: UIView {
    
    // MARK: - Empty state
     
    let emptyStateView: UIView = {
        let v = UIView()
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
 
    let emptyIconLabel: UILabel = {
        let l = UILabel()
        l.text = "🤍"
        l.font = UIFont.systemFont(ofSize: 56)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
 
    let emptyTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "No favorites yet"
        l.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        l.textColor = .label
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
 
    let emptySubtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Swipe right on any song to save it here"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // Mark: - Table
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        tv.register(SongTableViewCell.self, forCellReuseIdentifier: SongTableViewCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // Mark: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lyricaIvory
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showEmpty(_ isEmpty: Bool) {
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    // Mark: - Layout
    
    private func setupLayout() {
            [emptyIconLabel, emptyTitleLabel, emptySubtitleLabel].forEach {
                emptyStateView.addSubview($0)
            }
            [tableView, emptyStateView].forEach { addSubview($0) }
     
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
     
                emptyStateView.centerXAnchor.constraint(equalTo: centerXAnchor),
                emptyStateView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
     
                emptyIconLabel.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
                emptyIconLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
     
                emptyTitleLabel.topAnchor.constraint(equalTo: emptyIconLabel.bottomAnchor, constant: 12),
                emptyTitleLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
     
                emptySubtitleLabel.topAnchor.constraint(equalTo: emptyTitleLabel.bottomAnchor, constant: 8),
                emptySubtitleLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
                emptySubtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
                emptySubtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                emptySubtitleLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
            ])
        }
}
