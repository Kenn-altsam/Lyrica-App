

import Foundation
import FirebaseCore

final class AppConfigurator {
    
    private init() {}
    
    static func configure() {
        FirebaseApp.configure()
    }
}
