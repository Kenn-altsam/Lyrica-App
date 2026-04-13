//
//  AppConfigurationManager.swift
//  Lyrica
//
//  Created by Altynbek Kenzhe on 04.04.2026.
//

import Foundation
import FirebaseCore

final class AppConfigurator {
    
    private init() {}
    
    static func configure() {
        FirebaseApp.configure()
    }
}
