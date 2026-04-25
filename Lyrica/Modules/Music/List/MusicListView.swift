
import UIKit

final class MusicListView: UIView {
    
    // MARK: - UI Components (internal — ViewController настраивает dataSource/delegate)
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .lyricaIvory
        tv.separatorStyle = .none
        tv.rowHeight = 84
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
 
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .lyricaShamrock
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
 
    let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "No tracks found"
        l.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        l.textColor = .secondaryLabel
        l.textAlignment = .center
        l.isHidden = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    // MARK: - Init
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lyricaIvory
        setupLayout()
    }
 
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Layout (только layout — ничего больше)
 
    private func setupLayout() {
        addSubview(tableView)
        addSubview(activityIndicator)
        addSubview(emptyLabel)
 
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
 
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
 
            emptyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
 
    // MARK: - State helpers (только UI-состояние, без логики)
 
    func showEmpty(_ isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
}
