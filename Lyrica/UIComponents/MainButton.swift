
import UIKit
import Combine

class MainButton: UIButton {
    
    private let touchUpInsideSubject: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    var touchUpInsidePublisher: AnyPublisher<Void, Never> {
        touchUpInsideSubject.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
    
    @objc
    private func didTouchUpInside() {
        touchUpInsideSubject.send()
    }
    
    func setEnabled(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        self.alpha = isEnabled ? 1 : 0.5
    }
}
