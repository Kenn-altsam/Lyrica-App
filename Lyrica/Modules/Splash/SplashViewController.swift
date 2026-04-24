
import UIKit

final class SplashViewController: UIViewController {
    
    var onFinish: (() -> Void)?
    
    private let backgroundCircle: UIView = {
            let v = UIView()
            v.backgroundColor = .lyricaShamrock
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
    
    // Иконка ноты — символ приложения
        private let noteLabel: UILabel = {
            let l = UILabel()
            l.text = "♪"
            l.font = UIFont.systemFont(ofSize: 80, weight: .bold)
            l.textColor = .white
            l.textAlignment = .center
            l.translatesAutoresizingMaskIntoConstraints = false
            // alpha = 0 означает невидимый. Мы покажем его анимацией
            l.alpha = 0
            return l
        }()
    
    
    // App name
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Lyrica"
        l.font = UIFont.systemFont(ofSize: 42, weight: .bold)
        l.textColor = .white
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        l.alpha = 0
        return l
    }()
 
    // Subtitle
    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Your music marketplace"
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        l.textColor = UIColor.white.withAlphaComponent(0.8)
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        l.alpha = 0
        return l
    }()
    
    // Mark: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lyricaShamrock
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runAnimation()
    }
    
    private func setupLayout() {
        [backgroundCircle, noteLabel, titleLabel, subtitleLabel].forEach {
            view.addSubview($0)
        }
        
        let size = UIScreen.main.bounds.width * 0.75
        
        NSLayoutConstraint.activate([
            // Круг — по центру, чуть выше середины экрана
            backgroundCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            backgroundCircle.widthAnchor.constraint(equalToConstant: size),
            backgroundCircle.heightAnchor.constraint(equalToConstant: size),
 
            // Нота — по центру круга
            noteLabel.centerXAnchor.constraint(equalTo: backgroundCircle.centerXAnchor),
            noteLabel.centerYAnchor.constraint(equalTo: backgroundCircle.centerYAnchor),
 
            // Название — под кругом
            titleLabel.topAnchor.constraint(equalTo: backgroundCircle.bottomAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
 
            // Подзаголовок — под названием
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        backgroundCircle.layer.cornerRadius = size / 2
        
    }
    
    private func runAnimation() {
        noteLabel.transform = CGAffineTransform(scaleX: 0, y: 20)
        
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseOut) {
            self.noteLabel.alpha = 1
            self.noteLabel.transform = .identity
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseOut) {
            self.titleLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.6, options: .curveEaseOut) {
            self.subtitleLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.4, delay: 2.0, options: .curveEaseIn) {
            self.view.alpha = 0
            
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } completion: { _ in
            self.onFinish?()
        }
    }
    
}
